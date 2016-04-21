require 'spec_helper'

module Filterable
  describe Base do
    before :each do 
      class SimpleModel < ActiveRecord::Base; end
    end

    it 'provides .filter_by to the model' do
      expect(SimpleModel).to respond_to :filter_by
    end

    it 'calls #generate on Filter when .filter_by is invoked' do
      filters = [:name, :title]
      expect(Filter).to receive(:generate).with(SimpleModel, filters)

      SimpleModel.filter_by *filters
    end
  end
end
