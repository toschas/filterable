module Generators
  class Base
    attr_reader :model, :filters, :options

    def initialize(model, filters, options)
      @model = model
      @filters = filters
      @options = options
    end

    def generate
    end

    private

    def range_types
      [:date, :datetime, :integer, :float, :decimal]
    end
  end
end
