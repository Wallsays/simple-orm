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
     course_id interger,
     group_id integer
   );
  SQL
  p "--> done"

  p "--- Creating Rooms Table (#{env})---"
  rooms = db.execute <<-SQL
   create table rooms (
     id  integer PRIMARY KEY,
     number integer,
     student_id integer
   );
  SQL
  p "--> done"

  p "--- Creating Courses Table (#{env})---"
  courses = db.execute <<-SQL
   create table courses (
     id  integer PRIMARY KEY,
     number integer
   );
  SQL
  p "--> done"

  p "--- Creating Groups Table (#{env})---"
  groups = db.execute <<-SQL
   create table groups (
     id  integer PRIMARY KEY,
     number integer
   );
  SQL
  p "--> done"

  p "--- Creating Vehicle Table (#{env})---"
  groups = db.execute <<-SQL
   create table vehicles (
     id  integer PRIMARY KEY,
     reg_number VARCHAR(30),
     tyre_ids VARCHAR(256),
     important_part_ids VARCHAR(256)
   );
  SQL
  p "--> done"

  p "--- Creating Tyres Table (#{env})---"
  groups = db.execute <<-SQL
   create table tyres (
     id  integer PRIMARY KEY
   );
  SQL
  p "--> done"

  p "--- Creating ImportantParts Table (#{env})---"
  groups = db.execute <<-SQL
   create table important_parts (
     id  integer PRIMARY KEY
   );
  SQL
  p "--> done"
end
