require 'spec_helper'

module Filterable
  describe 'Configuration' do
    before :all do
      @config = Configuration.new
    end

    it 'has accessors for configuration options' do
      expect(@config).to respond_to :ignore_unknown_filters
      expect(@config).to respond_to :ignore_unknown_filters=

      expect(@config).to respond_to :ignore_empty_values
      expect(@config).to respond_to :ignore_empty_values=
    end

    it 'has default values' do
      expect(@config.ignore_unknown_filters).to be true
      expect(@config.ignore_empty_values).to be true
    end
  end
end
