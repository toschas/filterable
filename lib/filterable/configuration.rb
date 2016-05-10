module Filterable
  class Configuration
    attr_accessor :ignore_unknown_filters, :ignore_empty_values

    def initialize
      @ignore_unknown_filters = true
      @ignore_empty_values = true
    end
  end
end
