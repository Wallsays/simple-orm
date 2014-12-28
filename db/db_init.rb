require "sqlite3"

%w(dev test).each do |env|
  
  # Open a database
  db = SQLite3::Database.new "#{env}.db" 

  p "--- Creating Students Table (#{env})---"
  studs = db.execute <<-SQL
   create table students (
      id  integer PRIMARY KEY,
      name varchar(30),
      email varchar(30),
      options varchar(256)
    );
  SQL
  p "--> done"

end