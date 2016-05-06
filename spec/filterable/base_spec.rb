require 'spec_helper'

module Filterable
  describe Base do
    it 'provides .filter_by to the model' do
      expect(Dashboard).to respond_to :filter_by
    end

    it 'calls #generate on Generator when .filter_by is invoked' do
      filters = [:name, :title]
      generator = double(Generator.new(Dashboard, filters))
      expect(Generator).to(
        receive(:new).with(Dashboard, filters).and_return(generator)
      )
      expect(generator).to receive(:generate)

      Dashboard.filter_by *filters
    end
  end
end
