module Filterable
  module Base
    module ClassMethods
      def filter_by(*args)
        Filter.generate(self, args)
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end
  end
end
