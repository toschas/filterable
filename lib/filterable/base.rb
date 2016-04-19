module Filterable
  module Base
    module ClassMethods
      def filter(filtering_params)
        results = where(nil)
        filtering_params.each do |key, value|
          results = results.public_send(key, value) if results.respond_to? key
        end
        results
      end

      def filter_by(*args)
        args.each do |filt|
          self.define_singleton_method(
            "by_#{filt}", 
            ->(value) { self.send(:where, { filt => value }) }
          )
        end
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end
  end
end
