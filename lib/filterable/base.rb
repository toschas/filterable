module Filterable
  module Base
    module ClassMethods
      def filter_by(*args)
        Generator.new(self, args).generate
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end
  end
end
