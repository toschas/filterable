module Generators
  class Custom < Base
    def generate
      prefixes = custom_prefixes
      filters.each do |filter|
        prefixes.each do |prefix|
          model.define_singleton_method(
            "#{prefix}_#{filter}", 
            ->(value) { send(:where, nil) }
          )
        end
      end
    end

    def custom_prefixes
      if options[:prefix].present?
        options[:prefix].is_a?(Array) ? options[:prefix] : [options[:prefix]]
      else
        ['by']
      end
    end
  end
end
