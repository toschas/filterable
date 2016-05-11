require 'spec_helper'

module Filterable
  describe 'Configure' do
    it 'ignores empty values by default' do
      result = User.filter(by_name: '')

      expect(result.size).to eq User.count
    end

    it 'filters by empty values if configured' do
      allow_any_instance_of(Configuration)
        .to receive(:ignore_empty_values).and_return(false)
      result = User.filter(by_name: '')

      expect(result.size).to eq 0
    end

    it 'ignores unknown filters by default' do
      result = Company.filter(by_undefined: 'test')

      expect(result.size).to eq Company.count
    end

    it 'raises error for unknown filter when configured' do
      allow_any_instance_of(Configuration)
        .to receive(:ignore_unknown_filters).and_return(false)
      expect { Company.filter(by_undefined: 'test') }
        .to raise_error(UnknownFilter, 'Unknown filter received: by_undefined')
    end
  end
end
