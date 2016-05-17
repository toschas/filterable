module Generators
  class Joined < Base
    def generate
      filters.each do |filter|
        field = joined_field(filter)
        generate_joined_filter(filter, field, relation_name, options[:joins])
        if range_filter?(field)
          generate_range_filter(filter, field, relation_name, options[:joins])
        end
      end
    end

    private

    def generate_joined_filter(filter, field, relation_name, join_options)
      model.define_singleton_method(
        "by_#{filter}",
        ->(value) {
          send(:joins, join_options)
          .send(:where, 
                { relation_name.to_s.pluralize => { 
            field => value } 
          }
               )
        }
      )
    end

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


    def extract_relations(join_options)
      if join_options.is_a?(Hash)
        join_options.flat_map{|k, v| [k, *extract_relations(v)]}
      else
        [join_options]
      end
    end

    def relations
      @relations ||= extract_relations(options[:joins])
    end

    def relation_name
      @relation_name ||= relations.last
    end

    def joined_field(filter)
      filter.to_s.split("#{relation_name}_").last
    end

    def range_filter?(filter)
      range_types.include?(
        relation_name.to_s.classify.constantize
        .type_for_attribute(filter.to_s).type
      )
    end
  end
end
