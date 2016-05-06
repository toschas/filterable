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
        another_model_filters = [:another_model_another_attribute, 
                                 joins: :another_model]
        Generator.new(Dashboard, user_filters).generate
        Generator.new(Dashboard, another_model_filters).generate

        expect(Dashboard).to respond_to :by_user_id
        expect(Dashboard).to respond_to :by_another_model_another_attribute
      end

      it 'generates filter scopes for nested joined models' do
        filters = [:user_post_title, joins: { user: :post }]
        Generator.new(Dashboard, filters).generate

        expect(Dashboard).to respond_to :by_user_post_title
      end

      it 'generates custom filter method if custom option is sent' do
        filters = [:custom_filter, custom: true]
        Generator.new(Dashboard, filters).generate

        expect(Dashboard).to respond_to :by_custom_filter
      end
    end

  end 
end
