require 'active_record'
require_relative 'schema_helper'

class App
  class << self
    def init
      database_connect
      generate_schema
      load_models
      create_models
    end

    def database_connect
      SchemaHelper.connect_to('sqlite3', ':memory:')
    end

    def generate_schema
      SchemaHelper
        .generate_model(:dashboard, 
                        { name: 'string', title: 'string', body: 'text', 
                          configured_on: 'date', widgets_count: 'integer', 
                          created_at: 'datetime', updated_at: 'datetime' })
        .generate_model(:user, { name: 'string', email: 'string', 
                                 role: 'references' }) 
        .generate_model(:role, { name: 'string' }) 
        .generate_model(:company, { title: 'string' }) 
        .generate_model(:project, { title: 'string', company: 'references', 
                                    deadline_on: 'date' }) 
        .generate_model(:task, { title: 'string', project: 'references', 
                                 finished_at: 'datetime' })
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

    def load_models
      require_relative 'models'
    end
  end
end

