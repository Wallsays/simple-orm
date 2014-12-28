class Room < SimpleRecord
  attr_accessor :number

  one_to_one_assoc_with :student
end

