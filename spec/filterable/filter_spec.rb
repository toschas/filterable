require 'spec_helper'
require 'support/schema_helper'

module Filterable
 describe Filter do
   before :all do
     SchemaHelper.new.connect_to('sqlite3', ':memory:')
       .generate_model('simple_model', { name: 'string', title: 'string' })
   end

   describe '.generate' do
     it 'generates filter methods' do
       Filter.generate(SimpleModel, [:name, :title])

       expect(SimpleModel).to respond_to :filter
       expect(SimpleModel).to respond_to :by_name
       expect(SimpleModel).to respond_to :by_title
     end
   end

   describe '.filter' do
     before :all do
       Filter.generate(SimpleModel, [:name, :title])
     end

     it 'queries by each param if filter defined' do
       params = { by_name: 'test', by_title: 'test' }

       result = SimpleModel.filter params

       params.each do |key, value|
         column_name = key.to_s.split('by_').last
         pattern = /"simple_models"."#{column_name}" = '#{value}'/
         expect(pattern.match(result.to_sql)).not_to be_nil
       end
     end

     it 'returns ActiveRecord::Relation' do
       expect(SimpleModel.filter({})).to be_an ActiveRecord::Relation
     end

     it 'ignores params for which filter is not defined' do
       expect { SimpleModel.filter(by_unknown_attribute: 'test') }.not_to raise_error
       expect(
         /"simple_models"."unknown_attribute"/.match(
           SimpleModel.filter(by_unknown_attribute: 'test').to_sql
         )
       ).to be_nil
     end

     it 'ignores params where value is empty' do
       expect(SimpleModel).not_to receive :by_name
       SimpleModel.filter(by_name: '')
     end

     it 'supports joined models query' do

     end
   end
 end 
end
