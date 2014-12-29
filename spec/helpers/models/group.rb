class Group < SimpleRecord
  attr_accessor :number

  many_to_one_backward_assoc_with :student
end
