class SchemaHelper
  class << self
    def connect_to(adapter, database)
       ActiveRecord::Base.establish_connection(
         adapter: adapter,
         database: database
       )
       self
    end

    def generate_model(model_name, attributes)
       ActiveRecord::Schema.define do
         create_table model_name.to_s.pluralize, force: true do |t|
           attributes.each do |attribute, column_type|
             t.send(column_type, attribute)
           end
         end
       end

       unless Object.const_defined? model_name.to_s.classify
         Object.const_set(model_name.to_s.classify, Class.new(ActiveRecord::Base)) 
       end

       self
    end
  end
end
