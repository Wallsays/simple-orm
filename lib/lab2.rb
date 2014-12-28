require "sqlite3"

# Open a database
db = SQLite3::Database.new "test.db" 

# studs = db.execute <<-SQL
#  create table students (
#     id  integer PRIMARY KEY,
#     name varchar(30),
#     email varchar(30),
#     options varchar(256)
#   );
# SQL

# # Find a few rows
p '---------- BEFORE -----------'
db.execute( "select * from students" ) do |row|
  p row
end

#-------------
## CLASS API
#-------------
class SimpleRecord
  
  @@db = SQLite3::Database.new "test.db" 
  
  attr_accessor :id


  def self.find(id)
    result = nil
    @@db.execute( "select * from #{table_name} where id=#{id} limit 1" ) do |row|
      result = self.new(row[1], row[2], row[3])
      result.id = row[0]
    end
    return "Record not found" if !result
    result
  end

  def self.where(args)
    p args
    args = args.map{|k,v| "#{k} == '#{v}'"}.join(' AND ') if args.class == Hash
    result = []
    query = "select * from #{table_name} where #{args}" 
    p query
    @@db.execute(query) do |row|
      tmp = self.new(row[1], row[2], row[3])
      tmp.id = row[0]
      result << tmp
    end
    return "Record not found" if !result
    result
  end

  def save
    if instance_variables.to_s.include?('id')
      query = "UPDATE #{self.class.table_name} set #{name_vals} where id=#{self.id}"
      @@db.execute(query)
    else
      query = "INSERT INTO #{self.class.table_name} (#{attrs_names}) VALUES (#{attrs_vals})"
      @@db.execute(query)
      self.id = @@db.last_insert_row_id
    end
    self
  end

  def destroy
    return "Record w/o id (not saved yet)" if !self.id
    query = "DELETE from #{self.class.table_name} WHERE id=#{self.id}"
    @@db.execute(query)
  end

  #-------------
  ## HELPERS
  #-------------
  def self.table_name
    self.to_s.downcase + 's'
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
    instance_variables.map{|v| "#{v[1..-1].to_s}='#{instance_variable_get(v)}'," }.
      join(' ').gsub(/, id=.*/,'')
  end
end

#-------------
## TEST CLASS
#-------------
class Student < SimpleRecord
  attr_accessor :email, :name, :options

  def initialize(name = 'testBBB', email = 'testBBB@mail.com', options = {} )
    @name = name
    @email = email
    @options = options.to_s
  end
end


p '============ CRITICAL SECTION ==========='
# p stud = Student.new
# p stud.save
# p stud.destroy
# p st = Student.find(15)
# st.name = "WOWA#{rand(10)}"
# st.email = "#{st.name}@mail.com"
# st.save
p st = Student.where(" id >= 2 AND (options != '{}' OR email == 'testBBB@mail.com') ")
p st = Student.where( options: {}, email: 'testBBB@mail.com') # { :_and => {id: 2, _or: {options: {}, email: {_not: "testBBB@mail.com"} }} }
p '========================================='


p '---------- AFTER -----------'
db.execute( "select * from students" ) do |row|
  p row
end
