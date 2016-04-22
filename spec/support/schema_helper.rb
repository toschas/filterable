class SchemaHelper
  def connect_to(adapter, database)
     ActiveRecord::Base.establish_connection(
       adapter: 'sqlite3',
       database: ':memory:'
     )
     self
  end

  def generate_model(model_name, attributes)
     ActiveRecord::Schema.define do
       create_table model_name.pluralize, force: true do |t|
         attributes.each do |attribute, column_type|
           t.send(column_type, attribute)
         end
       end
     end

     Object.const_set(model_name.classify, Class.new(ActiveRecord::Base))
     self
  end
end
