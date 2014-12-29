class Tyre < SimpleRecord
  one_to_many_backward_assoc_with :vehicle
end
