module Generators
  class Custom < Base
    def generate
      prefixes = custom_prefixes
      filters.each do |filter|
        prefixes.each do |prefix|
          filter_name = prefix == :none ? "#{filter}" : "#{prefix}_#{filter}"
          model.define_singleton_method(
            filter_name, 
            ->(_value) { send(:where, nil) }
          )
        end
      end
    end

    def custom_prefixes
      prefix = options[:prefix].blank? ? 'by' : options[:prefix]
      ensure_prefix_array(prefix)
    end

    def ensure_prefix_array(prefix)
      prefix.is_a?(Array) ? prefix.reject(&:blank?) : [prefix]
    end
  end
end
