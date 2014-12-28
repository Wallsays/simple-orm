require_relative 'config'
require_relative 'string'
require_relative 'object'

#-------------
## CLASS API
#-------------
class SimpleRecord
  
  @@db = SimpleORM.db
  @@db.results_as_hash = true
  
  attr_accessor :id


  def self.find(id)
    return nil if id.blank?
    query = "select * from #{table_name} where id=#{id} limit 1"
    result = self.new
    @@db.execute(query).first.try(:each) do |k, v|
      next if k.is_a? Integer
      result.instance_variable_set('@' + k, v)
    end
    return "Record not found" if result.id.blank?
    result
  end

  def self.where(args)
    # args = args.map{|k,v| "#{k} == '#{v}'"}.join(' AND ') if args.class == Hash
    args = args.map do |k,v| 
      if k == :__op__
        "#{v}" 
      elsif k.to_s.include?('.')
        "#{k[0..k.length-4]} != '#{v}'"
      else  
        "#{k} == '#{v}'"
      end
    end.join(' ') if args.class == Hash
    result = []
    query = "select * from #{table_name} where #{args}" 
    query_result = @@db.execute(query)
    query_result.each do |row|
      sample = self.new
      row.each do |k, v|
        next if k.is_a? Integer
        hash = ''
        begin 
          hash = eval(v) 
        rescue
        end
        v = hash if hash.is_a?(Hash)
        sample.instance_variable_set('@' + k, v)
      end 
      result << sample
    end  if query_result
    return "Record not found" if !result
    result
  end

  def save
    if !id.blank?
      return self if (nv = name_vals).blank?

      query = "UPDATE #{table_name} set #{name_vals} where id=#{self.id}"
      @@db.execute(query)
    else
      query = if instance_variables.any? {|v| v != :@id}
                "INSERT INTO #{table_name} (#{attrs_names}) VALUES (#{attrs_vals})"
              else
                "INSERT INTO #{table_name} DEFAULT VALUES"
              end
      @@db.execute(query)
      self.id = @@db.last_insert_row_id
    end
    self
  end

  def destroy
    return "Record w/o id (not saved yet)" if self.id.blank?
    query = "DELETE from #{table_name} WHERE id=#{self.id}"
    @@db.execute(query)
  end

  #-------------
  ## HELPERS
  #-------------
  def self.table_name
    self.name.downcase.to_plural
  end

  def table_name
    self.class.table_name
  end

  # [:@name, :@email, :@options] --> "name,email,options" 
  def attrs_names
    instance_variables.map{|v| v[1..-1].to_s}.join(',') 
  end
  
  # "testBBB", "testBBB@mail.com", "{}"
  def attrs_vals
    instance_variables.map{|ivar| "'#{ instance_variable_get ivar}'" }.join(',')
  end

  # "name='testBBB', email='testBBB@mail.com', options='{}'"
  def name_vals
    instance_variables.select { |v| v != :@id }.map { |v| "#{v[1..-1].to_s}='#{instance_variable_get(v)}'" }.
      join(', ')
  end

  #------------
  ##
  #------------
  def self.before(*names)
    names.each do |name|
      m = instance_method(name)
      define_method(name) do |*args, &block|  
        yield
        m.bind(self).(*args, &block)
      end
    end
  end

  def self.one_to_one_assoc_with(fclass_name)
    fclass_name = fclass_name.to_s unless fclass_name.is_a? String

    self.send(:define_method, "#{fclass_name}=".to_sym) do |val|
      instance_variable_set("@" + fclass_name + '_id', val.id)
      return self if val.instance_variable_get("@#{self.class.to_s.downcase}_id") == self.id
      val.send("#{self.class.to_s.downcase}=".to_sym, self)
    end

    self.send(:define_method, fclass_name.to_sym) do
      fk = instance_variable_get('@' + fclass_name + '_id')
      fclass_name.to_class.find(fk) unless fk.blank? 
    end
  end

  def self.has_many_assoc_with(fclass_name, options = {})
    fclass_name = fclass_name.to_s unless fclass_name.is_a? String

    send(:define_method, fclass_name.plural_setter_name.to_sym) do |vals|
      vals.map {|v| v.send(self.setter_name.to_sym, self); v.save}
    end

    send(:define_method, fclass_name.plural_getter_name.to_sym) do
      fclass_name.to_class.where(self.id_key_name.to_sym => self.id)
    end

    add_dependence_destroy_on(fclass_name) if (options.blank? || options[:dependence_destroy]) 
  end

  def self.one_of_assoc_with(fclass_name, dep_destroy = false)
    fclass_name = fclass_name.to_s unless fclass_name.is_a? String

    class_eval do
      define_method fclass_name.setter_name.to_sym do |val|
        instance_variable_set fclass_name.id_var_name, val.id
      end

      define_method fclass_name.getter_name.to_sym do
        target_id = instance_variable_get(fclass_name.id_var_name)
        fclass_name.to_class.find(target_id) unless target_id.blank?
      end
    end
  end

  def inst_var_name
    self.class.inst_var_name
  end

  def self.inst_var_name
    '@' + self.name.downcase
  end

  def setter_name
    self.class.setter_name
  end

  def self.setter_name
    self.name.downcase + '='
  end

  def plural_setter_name
    self.class.plural_setter_name
  end

  def self.plural_setter_name
    self.name.downcase.to_plural + '='
  end

  def getter_name
    self.class.getter_name
  end

  def self.getter_name
    self.name.downcase
  end

  def plural_getter_name
    self.class.plural_getter_name
  end

  def self.plural_getter_name
    self.name.downcase.to_plural
  end

  def self.add_dependence_destroy_on dep_class
    dep_class = dep_class.to_s unless dep_class.is_a?(String)

    self.class_eval do
      m = self.instance_method(:destroy)

      define_method(:destroy) do |*args, &block|  
        dep_class.to_class.where(self.id_key_name.to_sym => self.id).each do |inst|
          inst.destroy
        end
        m.bind(self).(*args, &block)
      end
    end
  end

  def is_foreign_assigned?(fi)
    fi.has_fk_of? self
  end

  def has_fk_of?(fi)
    fk = self.instance_variable_get('@' + fi.class.name.downcase + '_id') ||
         self.instance_variable_get('@' + fi.class.name.downcase + '_ids')
    # Если fk непусто и её значение совпадает со значением fi.id либо fk непусто и она содержит fi.id (когда fk массив)
    !fk.blank? && (fk == fi.id || (fk.is_a?(Array) && fk.include?(fi.id)))
  end


  def self.foreign_key
    self.to_s.downcase + '_id'
  end

  def self.table_exist?
    @@db.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='#{table_name}'").count != 0
  end

  #----------------- id name ----------------------

  def id_key_name
    self.class.id_key_name
  end

  def self.id_key_name
    self.name.downcase + '_id'
  end
   
end
