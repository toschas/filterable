require 'spec_helper'
require 'support/schema_helper'

module Filterable
 describe Generator do
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
