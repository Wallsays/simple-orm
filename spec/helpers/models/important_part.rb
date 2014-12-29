class ImportantPart < SimpleRecord
  one_to_many_backward_assoc_with :vehicle, dep_destroy: true
end
