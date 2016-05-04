require 'spec_helper'
require 'support/schema_helper'

module Filterable
  describe Generator do
    describe '.generate' do
      before :all do 
        class SimpleModel < ActiveRecord::Base; end
      end

      it 'generates filter methods' do
        Generator.new(SimpleModel, [:name, :title]).generate

        expect(SimpleModel).to respond_to :filter
        expect(SimpleModel).to respond_to :by_name
        expect(SimpleModel).to respond_to :by_title
      end

      it 'generates filter scopes for joined models' do
        user_filters = [:user_id, joins: :user]
        another_model_filters = [:another_model_another_attribute, joins: :another_model]
        Generator.new(SimpleModel, user_filters).generate
        Generator.new(SimpleModel, another_model_filters).generate

        expect(SimpleModel).to respond_to :by_user_id
        expect(SimpleModel).to respond_to :by_another_model_another_attribute
      end

      it 'generates filter scopes for nested joined models' do
        filters = [:user_post_title, joins: { user: :post }]
        Generator.new(SimpleModel, filters).generate

        expect(SimpleModel).to respond_to :by_user_post_title
      end
    end

  end 
end
