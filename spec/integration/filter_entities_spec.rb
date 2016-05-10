require 'spec_helper'

module Filterable
  describe 'Filter Entities' do
    it 'returns entity filtered by the field' do
      result = User.filter(by_name: 'user0')

      expect(result.size).to eq 1
      expect(result.first.name).to eq 'user0'
    end

    it 'returns entities filtered with from and to filters' do
      result = Project.filter(from_deadline_on: Date.yesterday)

      expect(result.size).to be > 0
      result.each do |project|
        expect(project.deadline_on).to be > Date.yesterday
      end
    end

    it 'returns entities filtered by custom filter' do
      result = User.filter(by_custom_filter: '0')

      expect(result.size).to eq 1
      expect(result.first.name).to eq 'user0'
    end

    it 'chains filters' do
      result = Task.filter(by_user_id: 2, from_finished_at: Date.yesterday)

      expect(result.size).to be > 0
      result.each do |task|
        expect(task.user_id).to eq 2
        expect(task.finished_at).to be > Date.yesterday
      end
    end

    it 'returns entities filtered by joined model filters' do
      result = Role.filter(by_users_name: 'user0')

      expect(result.size).to eq 1
      expect(result.first.users.pluck(:name)
             .all?{ |n| n == 'user0' }).to be true
    end

    it 'returns entities filtered with from and to joined model filters' do
      result = Project.filter(from_tasks_finished_at: Date.yesterday)

      expect(result.size).to be > 0
      result.each do |project|
        expect(project.tasks.pluck(:finished_at)
               .all?{ |f| f > Date.yesterday }).to be true
      end
    end

    it 'chains joined filters' do
      result = Company.filter(by_projects_tasks_title: 'task0', 
                              to_projects_deadline_on: Date.today)

      expect(result.size).to be > 0
      result.each do |company|
        expect(company.projects.pluck(:deadline_on)
               .all?{ |d| d < Date.today }).to be true
        expect(company.tasks.pluck(:title).all? { |n| n == 'task0' }).to be true
      end
    end
  end
end

