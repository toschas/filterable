class SimpleGenerator
  attr_reader :model, :filters, :options

  def initialize(model, filters, options)
    @model = model
    @filters = filters
    @options = options
  end

  def generate
    filters.each do |filter|
      model.define_singleton_method(
        "by_#{filter}", 
        ->(value) { send(:where, { filter => value }) }
      )

      if range_filter?(filter)
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

  private

  def range_filter?(filter)
    [:date, :datetime, :integer].include?(
      model.to_s.classify.constantize
        .type_for_attribute(filter.to_s).type
    )
  end
end
