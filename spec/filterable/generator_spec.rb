require 'spec_helper'

module Filterable
  describe Generator do
    describe '.generate' do
      it 'generates filter methods' do
        Generator.new(Dashboard, [:name, :title]).generate

        expect(Dashboard).to respond_to :filter
        expect(Dashboard).to respond_to :by_name
        expect(Dashboard).to respond_to :by_title
      end

      it 'generates filter scopes for joined models' do
        user_filters = [:user_id, joins: :user]

        Generator.new(Role, user_filters).generate

        expect(Role).to respond_to :by_user_id
      end

      it 'generates filter scopes for nested joined models' do
        filters = [:projects_tasks_title, joins: { projects: :tasks }]
        Generator.new(Company, filters).generate

        expect(Company).to respond_to :by_projects_tasks_title
      end

      it 'generates custom filter method if custom option is sent' do
        filters = [:custom_filter, custom: true]
        Generator.new(Dashboard, filters).generate

        expect(Dashboard).to respond_to :by_custom_filter
      end

      it 'generates custom filter with prefix is one given' do
        filters = [:custom_filter, custom: true, prefix: :from]
        Generator.new(Dashboard, filters).generate

        expect(Dashboard).to respond_to :from_custom_filter
      end

      it 'can receive an array of prefixes for custom filters' do
        filters = [:test_filter, custom: true, prefix: [:to, :recent]]
        Generator.new(Dashboard, filters).generate

        expect(Dashboard).to respond_to :to_test_filter
        expect(Dashboard).to respond_to :recent_test_filter
      end

      it 'generates from and to filters for date and datetime fields' do
        Generator.new(Dashboard, [:configured_on, :created_at]).generate

        expect(Dashboard).to respond_to :by_configured_on
        expect(Dashboard).to respond_to :from_configured_on
        expect(Dashboard).to respond_to :to_configured_on
        expect(Dashboard).to respond_to :by_created_at
        expect(Dashboard).to respond_to :from_created_at
        expect(Dashboard).to respond_to :to_created_at
      end

      it 'generates from and to filters for float and decimal fields' do
        Generator.new(Task, [:logged_amount, :logged_hours]).generate

        expect(Task).to respond_to :by_logged_amount
        expect(Task).to respond_to :from_logged_amount
        expect(Task).to respond_to :to_logged_amount
        expect(Task).to respond_to :by_logged_hours
        expect(Task).to respond_to :from_logged_hours
        expect(Task).to respond_to :to_logged_hours
      end

      it 'generates from and to filters for integer fields' do
        Generator.new(Dashboard, [:widgets_count]).generate

        expect(Dashboard).to respond_to :by_widgets_count
        expect(Dashboard).to respond_to :from_widgets_count
        expect(Dashboard).to respond_to :to_widgets_count
      end

      it 'generates from and to filters for joined models' do
        Generator.new(Project, [:tasks_finished_at, { joins: :tasks }]).generate

        expect(Project).to respond_to :by_tasks_finished_at
        expect(Project).to respond_to :from_tasks_finished_at
        expect(Project).to respond_to :to_tasks_finished_at
      end

      it 'skips from and to filters for other types' do
        Generator.new(Dashboard, [:title, :body]).generate

        expect(Dashboard).not_to respond_to :from_title 
        expect(Dashboard).not_to respond_to :from_body 
        expect(Dashboard).not_to respond_to :to_title 
        expect(Dashboard).not_to respond_to :to_body 
      end
    end
  end 
end
