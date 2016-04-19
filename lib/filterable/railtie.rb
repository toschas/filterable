module Filterable
  class Railtie < Rails::Railtie
    initializer "railtie.configure_rails_initialization" do
      ActiveSupport.on_load(:active_record) do
        include Filterable::Base
      end
    end
  end
end
