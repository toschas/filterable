require 'active_record'
require_relative 'models'
require_relative 'schema_helper'

class App
  class << self
    def init
      database_connect
      generate_schema
      create_models
    end

    def database_connect
      SchemaHelper.connect_to('sqlite3', ':memory:')
    end

    def generate_schema
      SchemaHelper
        .generate_model(:user, { name: 'string' }) 
        .generate_model(:role, { name: 'string' }) 
        .generate_model(:company, { name: 'string' }) 
        .generate_model(:project, { name: 'string' }) 
        .generate_model(:task, { name: 'string' }) 
    end

    def create_models
      3.times do |n|
        User.create(name: "user#{n}")
        Role.create(name: "role#{n}")
        Company.create(name: "company#{n}")
        Project.create(name: "project#{n}")
        Task.create(name: "task#{n}")
      end
    end
  end
end


