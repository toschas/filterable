require_relative 'generators/base'
require_relative 'generators/custom'
require_relative 'generators/simple'
require_relative 'generators/joined'

module Filterable
  class Generator
    attr_accessor :model, :filters, :options

    def initialize(model, filters)
      @model = model
      @filters = filters
      @options = filters.last.is_a?(Hash) ? filters.pop : {}
    end

    def generate
      generate_filter unless model.respond_to? :filter
      generate_scopes
    end

    private

    def generate_filter
      model.define_singleton_method(
        :filter, 
        ->(filtering_params) {
          results = where(nil)
          filtering_params.each do |key, value|
            unless results.respond_to?(key)
              if Filterable.configuration.ignore_unknown_filters
                next
              else
                raise UnknownFilter, "Unknown filter received: #{key}"
              end
            end
            next if value.blank? && Filterable.configuration.ignore_empty_values
            results = results.public_send(key, value)
          end
          results
        }
      )
    end

    def generate_scopes
      if options[:custom]
        Generators::Custom.new(model, filters, options).generate
      elsif options[:joins].present?
        Generators::Joined.new(model, filters, options).generate
      else
        Generators::Simple.new(model, filters, options).generate
      end
    end
  end
end
