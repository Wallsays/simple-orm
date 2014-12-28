require_relative "../lib/lab2.rb"
require_relative "spec_helper"

describe SimpleRecord do 

  describe "CRUD actions" do
    
    it "insert new record to db" do
      stud = Student.new("Roman", "roman.l@gmail.com")
      stud.save
      # stud.id.should == 232
      expect(!stud.id != true).to eq true   # :id should present
      expect(stud.id > 0).to eq true        # :id should be > 0 (sqllite ex.)
    end

  end

end