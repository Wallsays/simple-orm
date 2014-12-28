require "rspec"
require_relative "../lib/config.rb"

SimpleORM.environment = :testing

# --- Remove Records from all tables ---
SimpleORM.db.execute <<-SQL
 DELETE FROM students;
 DELETE FROM rooms;
 DELETE FROM courses;
SQL
