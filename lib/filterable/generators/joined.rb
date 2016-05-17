module Generators
  class Joined < Base
    def generate
      options = self.options
      relation_name = joined_relation_name(options[:joins])
      filters.each do |filter|
        field = joined_field(filter, relation_name)
        model.define_singleton_method(
          "by_#{filter}",
          ->(value) {
            send(:joins, options[:joins])
            .send(:where, 
                  { relation_name.to_s.pluralize => { 
              field => value } 
            }
                 )
          }
        )

        if range_filter?(field, relation_name)
          generate_range_filter(filter, field, relation_name, options[:joins])
        end
      end
    end

    private

    def generate_range_filter(filter, field, relation_name, join_options)
      model.define_singleton_method(
        "from_#{filter}",
        ->(value) {
          send(:joins, join_options)
          .send(:where, 
                "#{relation_name.to_s.pluralize}.#{field} > ?", 
          value)
        }
      )

      model.define_singleton_method(
        "to_#{filter}",
        ->(value) {
          send(:joins, join_options)
          .send(:where, 
                "#{relation_name.to_s.pluralize}.#{field} < ?", 
          value)
        }
      )
    end

    def joined_relation_name(join_options)
      if join_options.is_a?(Hash) 
        joined_relation_name(join_options.values.last) 
      else
        join_options
      end
    end

    def joined_field(filter, relation_name)
      filter.to_s.split("#{relation_name}_").last
    end

    def range_filter?(filter, model_name = nil)
      model_name ||= model
      [:date, :datetime, :integer].include?(
        model_name.to_s.classify.constantize
        .type_for_attribute(filter.to_s).type
      )
    end
  end
end
