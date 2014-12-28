Object.class_eval do
  def blank?
    self.nil? || (self.class.method_defined?(:size) && self.size == 0)
  end
end