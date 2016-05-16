module Generators
  class Base
    attr_reader :model, :filters, :options

    def initialize(model, filters, options)
      @model = model
      @filters = filters
      @options = options
    end
  end
end
