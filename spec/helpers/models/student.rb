class Student < SimpleRecord
  attr_accessor :email, :name, :options

  one_to_one_assoc_with :room
  many_to_one_forward_assoc_with :course
  many_to_one_forward_assoc_with :group, dep_destroy: true

  def initialize(name = 'testBBB', email = 'testBBB@mail.com', options = {} )
    @name = name
    @email = email
    @options = options.to_s
  end
end
