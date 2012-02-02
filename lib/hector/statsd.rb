require "hector/ext/connection"
require "hector/statsd_service"

module Hector
  class << self
    attr_reader :statsd
    
    def statsd=(statsd)
      yield statsd if block_given?
      @statsd = statsd
      Hector::Session.register(@statsd)
    end
  end
end

Hector.statsd = Hector::StatsdService.new("Statsd")
