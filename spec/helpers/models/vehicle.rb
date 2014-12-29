class Vehicle < SimpleRecord
  attr_accessor :reg_number

  one_to_many_forward_assoc_with :tyre, dep_destroy: true
  one_to_many_forward_assoc_with :important_part
end
