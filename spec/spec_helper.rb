require "rspec"
require_relative "../lib/config.rb"

SimpleORM.environment = :testing

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
