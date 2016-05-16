module Generators
  class Joined < Base
    def generate
      options = self.options
      association_name = joined_association_name(options[:joins])
      filters.each do |filter|
        attribute_name = joined_attribute_name(filter, association_name)
        model.define_singleton_method(
          "by_#{filter}",
          ->(value) {
            send(:joins, options[:joins])
            .send(:where, 
                  { association_name.to_s.pluralize => { 
              attribute_name => value } 
            }
                 )
          }
        )

        if range_filter?(attribute_name, association_name)
          model.define_singleton_method(
            "from_#{filter}",
            ->(value) {
              send(:joins, options[:joins])
              .send(:where, 
                    "#{association_name.to_s.pluralize}.#{attribute_name} > ?", 
              value)
            }
          )

          model.define_singleton_method(
            "to_#{filter}",
            ->(value) {
              send(:joins, options[:joins])
              .send(:where, 
                    "#{association_name.to_s.pluralize}.#{attribute_name} < ?", 
              value)
            }
          )
        end
      end
    end

    private

    def joined_association_name(join_options)
      if join_options.is_a?(Hash) 
        joined_association_name(join_options.values.last) 
      else
        join_options
      end
    end

    def joined_attribute_name(filter, association_name)
      filter.to_s.split("#{association_name}_").last
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
