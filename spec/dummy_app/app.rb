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
                                 role: 'references', company: 'references' }) 
        .generate_model(:role, { name: 'string' }) 
        .generate_model(:company, { title: 'string' }) 
        .generate_model(:project, { title: 'string', company: 'references', 
                                    deadline_on: 'date' }) 
        .generate_model(:task, { title: 'string', project: 'references', 
                                 user: 'references', finished_at: 'datetime' })
    end

    def create_models
      2.times do |n|
        date = n > 0 ? Date.today : Date.yesterday
        role = Role.create(name: "role#{n}")
        company = Company.create(title: "company#{n}")
        user = User.create(name: "user#{n}", role: role, company: company )
        project = Project.create(title: "project#{n}", company: company, deadline_on: date)
        Task.create(title: "task#{n}", project: project, user: user, finished_at: date)
      end
    end

    def load_models
      require_relative 'models'
    end
  end
end

