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
        .generate_model(:dashboard, { name: 'string', title: 'string' })
        .generate_model(:user, { name: 'string', email: 'string', 
                                 role: 'references' }) 
        .generate_model(:role, { name: 'string' }) 
        .generate_model(:company, { title: 'string' }) 
        .generate_model(:project, { title: 'string', company: 'references' }) 
        .generate_model(:task, { title: 'string', project: 'references' })
    end

    def create_models
      2.times do |n|
        Role.create(name: "role#{n}")
        User.create(name: "user#{n}", )
        Company.create(title: "company#{n}")
        Project.create(title: "project#{n}")
        Task.create(title: "task#{n}")
      end
    end
  end
end


