class Course < SimpleRecord
  attr_accessor :number

  has_many_assoc_with :student, dependence_destroy: true
end
