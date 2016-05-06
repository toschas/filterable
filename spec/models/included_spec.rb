require 'spec_helper'

module Filterable
  describe 'Included Models' do
    describe '.filter' do
      it 'queries by each param if filter defined' do
        params = { by_name: 'user1', by_email: 'user1@filterable.com' }

        result = User.filter params

        params.each do |key, value|
          column_name = key.to_s.split('by_').last
          pattern = /"users"."#{column_name}" = '#{value}'/
          expect(pattern.match(result.to_sql)).not_to be_nil
        end
      end

      it 'uses custom filter defined in the model' do
        params = { by_custom_filter: 'test' }
        result = User.filter params
        pattern = /WHERE \(name LIKE 'test'\)/

        expect(pattern.match(result.to_sql)).not_to be_nil
      end

      it 'returns ActiveRecord::Relation' do
        expect(User.filter({})).to be_an ActiveRecord::Relation
      end

      it 'ignores params for which filter is not defined' do
        expect { 
          User.filter(by_unknown_attribute: 'test') 
        }.not_to raise_error

        expect(
          /"users"."unknown_attribute"/.match(
            User.filter(by_unknown_attribute: 'test').to_sql
          )
        ).to be_nil
      end

      it 'ignores params where value is empty' do
        expect(User).not_to receive :by_name
        User.filter(by_name: '')
      end
    end
  end
end
