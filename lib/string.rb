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
end