String.class_eval do
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
    self.capitalize.to_const
  end

  def setter_name
    self.downcase + '='
  end

  def getter_name
    self.downcase
  end

  def plural_setter_name
    self.downcase.to_plural + '='
  end

  def plural_getter_name
    self.downcase.to_plural
  end

  def inst_var_name
    '@' + self.downcase
  end

  def id_key_name
    self.downcase + '_id'
  end

  def id_var_name
    self.inst_var_name.id_key_name
  end
end

