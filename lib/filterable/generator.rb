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
      filters.each do |filter|
        if filter.is_a?(Hash)
          generate_joined_model_scope filter
        else
          generate_model_scope filter
        end
      end
    end

    def generate_joined_model_scope(filter)
      model.define_singleton_method(
        "by_#{filter.keys.first}_#{filter.values.first}",
        ->(value) { 
          send(:joins, filter.keys.first)
            .send(:where, { filter.keys.first => { filter.values.first => value } })
        } 
      )
    end

    def generate_model_scope(filter)
      model.define_singleton_method(
        "by_#{filter}", 
        ->(value) { send(:where, { filter => value }) }
      )
    end
  end
end
