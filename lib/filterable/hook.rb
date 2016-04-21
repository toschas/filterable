module Filterable
  class Hook
    def self.init
      ActiveSupport.on_load(:active_record) do
        include Filterable::Base
      end
    end
  end
end
