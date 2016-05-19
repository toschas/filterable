require "toschas/filterable/version"
require "active_record"
require "toschas/filterable/base"
require "toschas/filterable/hook"
require "toschas/filterable/generator"
require "toschas/filterable/configuration"

module Filterable
  UnknownFilter = Class.new(StandardError)
  Hook.init

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
