class Student < SimpleRecord
  attr_accessor :email, :name, :options

  one_to_one_assoc_with :room
  one_of_assoc_with :course

  def initialize(name = 'testBBB', email = 'testBBB@mail.com', options = {} )
    @name = name
    @email = email
    @options = options.to_s
  end
end
