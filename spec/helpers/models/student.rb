class Student < SimpleRecord
  attr_accessor :email, :name, :options

  has_one :room

  def initialize(name = 'testBBB', email = 'testBBB@mail.com', options = {} )
    @name = name
    @email = email
    @options = options.to_s
  end
end