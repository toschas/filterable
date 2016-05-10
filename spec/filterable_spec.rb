require 'spec_helper'

module Filterable
  describe 'Filterable' do
    it 'has a configuration object' do
      expect(Filterable).to respond_to :configuration
      expect(Filterable.configuration).to be_a(Configuration)
    end 

    it 'can be configured' do
      expect(Filterable).to respond_to :configure
    end

    it 'yields the configuration' do
      config_object = Filterable.configuration
      empty_block = -> {}

      expect do |empty_block|
        Filterable.configure &empty_block
      end.to yield_with_args(config_object)
    end
  end
end
