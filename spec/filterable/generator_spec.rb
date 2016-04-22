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
        filters = [:name, { user: :id }, { another_model: :another_attribute }]
        Generator.new(SimpleModel, filters).generate

        expect(SimpleModel).to respond_to :by_user_id
        expect(SimpleModel).to respond_to :by_another_model_another_attribute
      end
    end

  end 
end
