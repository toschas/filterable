require 'spec_helper'

module Filterable
  describe Base do
    it 'responds to #filter_by' do
      expect(Base).to respond_to :filter_by
    end
  end
end
