module Filterable
  class Generator
    attr_accessor :model, :filters

    def initialize(model, filters)
      @model = model
      @filters = filters
    end

    def generate
      generate_filter
      generate_scopes
    end

    private

    def generate_filter
      model.define_singleton_method(
        :filter, 
        ->(filtering_params) {
          results = where(nil)
          filtering_params.each do |key, value|
            next unless results.respond_to?(key) && value.present?
            results = results.public_send(key, value)
          end
          results
        }
      )
    end

    def generate_scopes
      filters.each do |filt|
        model.define_singleton_method(
          "by_#{filt}", 
          ->(value) { send(:where, { filt => value }) }
        )
      end
    end
  end
end
