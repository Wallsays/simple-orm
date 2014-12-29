require_relative 'simple_record'
require_relative "../spec/helpers/models/room"
require_relative "../spec/helpers/models/course"
require_relative "../spec/helpers/models/student"

# ******************************** DEBUGGING ********************************

db = SQLite3::Database.new "../db/dev.db"

# --- Remove Records from all tables ---
SimpleORM.db.execute <<-SQL
 DELETE FROM students;
SQL
SimpleORM.db.execute <<-SQL
 DELETE FROM rooms;
SQL
SimpleORM.db.execute <<-SQL
 DELETE FROM courses;
SQL

# p '---------- BEFORE -----------'
# db.execute( "select * from students" ) do |row|
#   p row
# end

# p '============ CRITICAL SECTION ==========='
# p stud = Student.new
# p stud.save
# p stud.destroy
# p st = Student.find(15)
# st.name = "WOWA#{rand(10)}"
# st.email = "#{st.name}@mail.com"
# st.save
# p st = Student.where(" id >= 2 AND (options != '{}' OR email == 'testBBB@mail.com') ")
# p st = Student.where( options: {}, __op__: 'AND', email: 'testBBB@mail.com')
# p st = Student.where( options: {}, __op__: 'OR', email: 'testBBB@mail.com')
# p st = Student.where( options: {}, __op__: 'AND', 'email.ne' => 'testBBB@mail.com')
# p '========================================='

# p '---------- AFTER -----------'
# db.execute( "select * from students" ) do |row|
#   p row
# end

p '---One-To-One and Has-Many, One-of association test---'

st1 = Student.new.save
st2 = Student.new.save
st3 = Student.new.save
r1 = Room.new.save
r2 = Room.new.save
r3 = Room.new.save
c = Course.new.save

c.students = [st1, st2, st3]
p ('has_many association makes 2 ways assigning and auto saves one_of association model: ' + Student.find(st1.id).course.inspect)

c.save
p ('Load course from db and show its students: ' + Course.find(c.id).students.inspect)

st1.room = r1
st2.room = r2
st3.room = r3
p ('Show student.room = r makes 2-ways assigning: ' + r1.student.inspect)

st1.save; st2.save; st3.save
p ('Show student.room is persisted: ' + Student.find(st1.id).room.inspect)

r1.save; r2.save; r3.save
p ('Show room.student is persisted: ' + Room.find(r1.id).student.inspect)

p ('Show loaded st1, r1, c: ' + Student.find(st1.id).inspect + ', ' + Room.find(r1.id).inspect + ', ' + Course.find(c.id).inspect)

c.destroy
p ('Dependence destroy: c is destroyed, st1, st2, st3 should be also destroyed: ' + [Student.find(st1.id), Student.find(st2.id), Student.find(st3.id)].inspect)
p ('Dependence destroy: c is destroyed, st1, st2, st3 should be also destroyed: ' + [st1, st2, st3].inspect)

p '------------------------------------------------------'
