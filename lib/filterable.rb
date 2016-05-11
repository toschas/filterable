require "filterable/version"
require "active_record"
require "filterable/base"
require "filterable/hook"
require "filterable/generator"
require "filterable/configuration"

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
