Object.class_eval do
  def blank?
    self.nil? || (self.class.method_defined?(:size) && self.size == 0)
  end

  def try(method_name, *params, &block)
    self.nil? ? nil : self.send(method_name.to_sym, *params, &block)
  end
end
