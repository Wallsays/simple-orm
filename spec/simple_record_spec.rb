require_relative "spec_helper"
require_relative "../lib/simple_record"
require_relative "helpers/models/room"
require_relative "helpers/models/student"
require_relative "helpers/models/course"

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

      it "where with 2 parameters and 'AND' " do
        studs = Student.where( options: {}, __op__: 'AND', name: 'alex' )
        expect(studs.size).to eq 1
        expect(studs.first.name == 'alex').to eq true
        expect(studs.first.options == {} ).to eq true
      end

      it "where with 2 parameters and 'OR' " do
        studs = Student.where( name: 'roman', __op__: 'OR', 'name' => 'alex' )
        expect(studs.size).to eq 2
        expect(%w(roman alex).include?(studs.first.name)).to eq true
      end

      it "where with 2 parameters, 'AND', 'NOT' " do
        studs = Student.where( name: 'roman', __op__: 'OR', 'name.ne' => 'alex' )
        expect(studs.size).to eq 3
        expect(%w(roman edward sally).include?(studs.first.name)).to eq true
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

  describe "Relations DSL" do
    before(:all) do
      st1 = Student.new('john', "john@mail.com").save
      st2 = Student.new('ray', "ray@mail.com").save
      st3 = Student.new('zack', "zack@mail.com").save
      r1 = Room.new.save
      r2 = Room.new.save
      r3 = Room.new.save

      c = Course.new.save
      c.students = [st1, st2, st3]
      c.save

      st1.room = r1
      st2.room = r2
      st3.room = r3
      st1.save; st2.save; st3.save
      r1.save; r2.save; r3.save
    end

    # describe "one-to-one" do
      it "checks setup of foreign keys" do
        st1 = Student.where(name: "john").first
        st2 = Student.where(name: "ray").first
        st3 = Student.where(name: "zack").first
        expect(st1.room.id).to eq 1
        expect(st1.course.id).to eq 1
        expect(Room.find(1).student.id).to eq st1.id
      end
    # end

    it "checks dependent destroy" do
      expect(Student.where('id >= 5').count).to eq 3
      c = Course.find(1)
      c.destroy
      expect(Student.where('id >= 5').count).to eq 0
    end

  end

end