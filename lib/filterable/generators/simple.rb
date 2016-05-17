module Generators
  class Simple < Base
    def generate
      filters.each do |filter|
        model.define_singleton_method(
          "by_#{filter}", 
          ->(value) { send(:where, { filter => value }) }
        )

        generate_range_filter(filter) if range_filter?(filter)
      end
    end

    private

    def range_filter?(filter)
      range_types.include?(
        model.to_s.classify.constantize
        .type_for_attribute(filter.to_s).type
      )
    end

    def generate_range_filter(filter)
      model.define_singleton_method(
        "from_#{filter}", 
        ->(value) { send(:where, "#{filter} > ?", value) }
      )

      model.define_singleton_method(
        "to_#{filter}", 
        ->(value) { send(:where, "#{filter} < ?", value) }
      )
    end
  end
end
