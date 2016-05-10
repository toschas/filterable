class Dashboard < ActiveRecord::Base
end

class User < ActiveRecord::Base
  belongs_to :role
  belongs_to :company
  has_many :tasks

  filter_by :name, :email 
  filter_by :custom_filter, custom: true

  def self.by_custom_filter(value)
    where('name LIKE ?', "%#{value}")
  end
end

class Role <ActiveRecord::Base
  has_many :users

  filter_by :users_name, joins: :users
end

class Company < ActiveRecord::Base
  has_many :projects
  has_many :users
  has_many :tasks, through: :projects

  filter_by :title
  filter_by :projects_tasks_name, joins: { projects: :tasks }
  filter_by :projects_deadline_on, joins: :projects
end

class Project < ActiveRecord::Base
  belongs_to :company
  has_many :tasks

  filter_by :tasks_title, :tasks_finished_at, joins: :tasks
  filter_by :deadline_on
end

class Task < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  filter_by :user_id
  filter_by :finished_at
end

