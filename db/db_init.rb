require "sqlite3"

%w(dev test).each do |env|
  
  # Open a database
  db = SQLite3::Database.new "#{env}.db" 

  p "--- Creating Students Table (#{env})---"
  studs = db.execute <<-SQL
   create table students (
     id integer PRIMARY KEY,
     name varchar(30),
     email varchar(30),
     options varchar(256),
     room_id integer,
     course_id interger
   );
  SQL

  p "--- Creating Rooms Table (#{env})---"
  rooms = db.execute <<-SQL
   create table rooms (
     id  integer PRIMARY KEY,
     number integer,
     student_id integer
   );
  SQL

  p "--- Creating Courses Table (#{env})---"
  courses = db.execute <<-SQL
   create table courses (
     id  integer PRIMARY KEY,
     number integer
   );
  SQL
  p "--> done"

end
