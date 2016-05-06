require 'spec_helper'

module Filterable
  describe 'Joined Models' do
    it 'queries by joined model fields' do
      query = Project.filter(by_tasks_title: 'test').to_sql

      expect(/JOIN "tasks"/.match(query)).not_to be_nil
      expect(/"tasks"."title" = 'test'/.match(query)).not_to be_nil
    end

    it 'queries by attribute on belogns to side' do
      query = Task.filter(by_user_id: 1).to_sql

      expect(/"tasks"."user_id" = 1/.match(query)).not_to be_nil
    end

    it 'queries by nested joined model fields' do
      query = Company.filter(by_projects_tasks_name: 'test').to_sql

      expect(/JOIN "projects"/.match(query)).not_to be_nil
      expect(/JOIN "tasks"/.match(query)).not_to be_nil
      expect(/"tasks"."name" = 'test'/.match(query)).not_to be_nil
    end
  end
end
