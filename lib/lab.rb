require_relative 'simple_record'
require_relative "../spec/helpers/models/room"
require_relative "../spec/helpers/models/course"
require_relative "../spec/helpers/models/group"
require_relative "../spec/helpers/models/student"
require_relative "../spec/helpers/models/tyre"
require_relative "../spec/helpers/models/vehicle"
require_relative "../spec/helpers/models/important_part"

# ******************************** DEBUGGING ********************************

db = SQLite3::Database.new "../db/dev.db"

# --- Remove Records from all tables ---
SimpleORM.db.execute <<-SQL
 DELETE FROM students;
SQL

db.execute <<-SQL
 DELETE FROM rooms;
SQL

db.execute <<-SQL
 DELETE FROM courses;
SQL

db.execute <<-SQL
 DELETE FROM tyres;
SQL

db.execute <<-SQL
 DELETE FROM vehicles;
SQL

db.execute <<-SQL
 DELETE FROM important_parts;
SQL

 %w(alex roman roman sally).each do |name|
        stud = Student.new(name, "#{name}@mail.com")
        stud.options = {a: rand(10)}
        stud.save
      end

# p '---------- BEFORE -----------'
# db.execute( "select * from students" ) do |row|
#   p row
# end

# p '============ CRITICAL SECTION ==========='
# p stud = Student.new('alex')
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

p '--- Many-To-One association test---'

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

st1 = Student.new.save
st2 = Student.new.save
g = Group.new.save

g.students = [st1, st2]
st1.destroy
p ('Test dep_destroy: st1 was destroyed, c must be destroyed too: ' + Group.find(g.id).inspect)
p '------------------------------------------------------'

p '--- Many-To-One association test---'
t1 = Tyre.new.save
t2 = Tyre.new.save
p (v = Vehicle.new.save).inspect

v.tyres = [t1, t2]
v.save
p ('Check v.tyres=: ' + v.tyres.inspect)
p ('Check t1.vehicle: ' + t1.vehicle.inspect)

p ('Check v.tyres persistent: ' + Vehicle.find(v.id).tyres.inspect)
p ('Check t1.vehicle persistent: ' + Tyre.find(t1.id).vehicle.inspect)

v.destroy
p ('Check dep_destroy, v destroyed, t1, t2 must be also: ' + [Tyre.find(t1.id).inspect, Tyre.find(t2.id)].inspect)

v = Vehicle.new.save
ip = ImportantPart.new.save

v.important_parts = [ip]
v.save


ip.destroy
p ('Check dep_destroy backward, ip destroyed, v must be destroyed: ' + Vehicle.find(v.id).inspect)
p '------------------------------------------------------'

# p '---------- AFTER -----------'
db.execute( "select * from students" ) do |row|
  p row
end

p studs = Student.where_proection( {name: 'roman' }, [:name, :options] )



