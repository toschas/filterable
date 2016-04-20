module Filterable
  class Filter
    def self.generate(klass, args)
      klass.define_singleton_method(
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

      args.each do |filt|
        klass.define_singleton_method(
          "by_#{filt}", 
          ->(value) { klass.send(:where, { filt => value }) }
        )
      end
    end
  end
end
