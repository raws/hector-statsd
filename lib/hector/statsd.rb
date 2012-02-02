module Hector
  class << self
    attr_reader :statsd
    
    def statsd=(statsd)
      yield statsd if block_given?
      @statsd = statsd
      Hector::Session.register(@statsd)
    end
  end
  
  class Connection
    def receive_line_with_statsd(*args)
      Hector.statsd.increment("traffic.in") if Hector.statsd
      receive_line_without_statsd(*args)
    end
    alias_method :receive_line_without_statsd, :receive_line
    alias_method :receive_line, :receive_line_with_statsd
    
    def send_data_with_statsd(*args)
      Hector.statsd.increment("traffic.out") if Hector.statsd
      send_data_without_statsd(*args)
    end
    alias_method :send_data_without_statsd, :send_data
    alias_method :send_data, :send_data_with_statsd
  end
  
  class StatsdService < Service
    attr_accessor :client, :namespace
    
    def increment(name)
      Hector.defer do
        name = "#{namespace.chomp(".")}.#{name}" if namespace
        client.increment(name) if client.respond_to?(:increment)
      end
    end
  end
end

Hector.statsd = Hector::StatsdService.new("Statsd")
