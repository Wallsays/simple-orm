require "sqlite3"

class SimpleORM
  class << self

    def config
      unless @instance
        yield(self) # !!!
      end
      @instance ||= self # сам этот класс (не экземпляр класса, а сам класс)
      # @instance.freeze   
    end

    attr_accessor :db, :db_name, :environment

    def environment=(env)
      @environment = env
      if env == :development
        @db = SQLite3::Database.new "../db/dev.db" 
        @db_name = 'dev'
      else
        @db = SQLite3::Database.new "../db/test.db" 
        @db_name = 'test'
      end
    end

  end
end

# Default config
SimpleORM.config do |app|
  app.environment = :development
end
