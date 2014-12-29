String.class_eval do
  def camelize
    self.split('_').map(&:capitalize).join
  end

  def underscore
    word = self.to_s.dup
    word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    word.downcase!
    word
  end

  def to_plural
    self + 's'
  end

  def to_single
    self[-1] = '' if (self.size > 0) && (self[-1] == 's')
  end

  def to_const
    Kernel.const_get(self)
  end

  def to_class
    self.camelize.to_const
  end

  def setter_name
    self.underscore + '='
  end

  def getter_name
    self.underscore
  end

  def plural_setter_name
    self.underscore.to_plural + '='
  end

  def plural_getter_name
    self.underscore.to_plural
  end

  def inst_var_name
    '@' + self.underscore
  end

  def id_key_name
    self.underscore + '_id'
  end

  def id_var_name
    self.inst_var_name.id_key_name
  end
end

