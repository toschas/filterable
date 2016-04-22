require 'spec_helper'
require 'support/schema_helper'

module Filterable
 describe Generator do
   before :all do
     SchemaHelper.new
       .connect_to('sqlite3', ':memory:')
       .generate_model('simple_model', { name: 'string', title: 'string' })
   end

   describe '.generate' do
     it 'generates filter methods' do
       Generator.new(SimpleModel, [:name, :title]).generate

       expect(SimpleModel).to respond_to :filter
       expect(SimpleModel).to respond_to :by_name
       expect(SimpleModel).to respond_to :by_title
     end
   end

 end 
end
