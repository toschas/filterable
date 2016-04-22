require 'spec_helper'

module Filterable
  describe Base do
    before :each do 
      class SimpleModel < ActiveRecord::Base; end
    end

    it 'provides .filter_by to the model' do
      expect(SimpleModel).to respond_to :filter_by
    end

    it 'calls #generate on Generator when .filter_by is invoked' do
      filters = [:name, :title]
      generator = double(Generator.new(SimpleModel, filters))
      expect(Generator).to receive(:new).with(SimpleModel, filters).and_return(generator)
      expect(generator).to receive(:generate)

      SimpleModel.filter_by *filters
    end
  end
end
