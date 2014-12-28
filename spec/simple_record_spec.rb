require_relative "spec_helper"
require_relative "../lib/lab2.rb"
require_relative "helpers/models/student"

RSpec.describe "SimpleRecord" do

  describe "CRUD actions" do
    it "insert new record" do
      stud = Student.new("Roman", "roman.l@gmail.com")
      stud.save
      expect(!stud.id != true).to eq true   # :id should present
      expect(stud.id).to eq 1               # :id should be 1 (sqllite ex.)
    end

    it "find inserted record" do
      stud = Student.find(1)
      expect(stud.name).to eq  'Roman'   
      expect(stud.email).to eq 'roman.l@gmail.com'  
    end    

    it "update record" do
      stud = Student.find(1)
      stud.name = "Alex"
      stud.save
      stud = Student.find(1)
      expect(stud.name).to eq  'Alex'   
      expect(stud.email).to eq 'roman.l@gmail.com'  
    end

    it "destroy record" do
      Student.find(1).destroy
      expect(Student.find(1)).to eq 'Record not found'   
    end

    it "trying to destroy not saved record" do
      stud = Student.new("Roman", "roman.l@gmail.com")
      expect(stud.destroy).to eq 'Record w/o id (not saved yet)'   
    end
  end

  describe "Query DSL" do

    before(:all) do
      %w(alex roman edward sally).each do |name|
        stud = Student.new(name, "#{name}@mail.com")
        stud.save
      end
    end

    describe "where with rails-like syntax" do
      it "where with 1 parameter" do
        studs = Student.where( options: {} )
        expect(studs.size).to eq 4
        expect( studs.map{|s| s.options == {} }.include?(false) ).to eq false
      end

      it "where with 2 parameters" do
        studs = Student.where( options: {}, name: 'alex' )
        expect(studs.size).to eq 1
        expect(studs.first.name == 'alex').to eq true
        expect(studs.first.options == {} ).to eq true
      end
    end

    describe "where with excplicit syntax" do
      it "where with 1 parameter" do
        studs = Student.where( " id > 2 ")
        expect(studs.size).to eq 2
        expect(studs.first.id > 2).to eq true
        expect(studs.last.id > 2).to eq true
      end

      it "where with AND, OR, NOT" do
        studs = Student.where(" id >= 2 AND (options != '{}' OR email == 'edward@mail.com') ")
        expect(studs.size).to eq 1
        expect(studs.first.id >= 2).to eq true
        expect(studs.first.options != {} || studs.first.email == 'edward@mail.com').to eq true
      end
    end

  end

end