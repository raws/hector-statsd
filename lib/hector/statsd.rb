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
    
    def track(stat_name, event_name, pattern = nil)
      intercepts_for(event_name.to_sym) << [stat_name, pattern]
    end
    
    def increment(name)
      Hector.defer do
        name = "#{namespace.chomp(".")}.#{name}" if namespace
        client.increment(name) if client.respond_to?(:increment)
      end
    end
    
    def method_missing(method_name, *args)
      run_intercepts_for(method_name) if intercepts.key?(method_name)
    end
    
    def respond_to_missing?(method_name, include_private)
      intercepts.key?(method_name)
    end
    
    protected
      def intercepts
        @intercepts ||= {}
      end
      
      def intercepts_for(event_name)
        intercepts[event_name] ||= []
      end
      
      def run_intercepts_for(event_name)
        intercepts_for(event_name).each do |stat_name, pattern|
          if pattern
            intercept(pattern) do
              increment(stat_name)
            end
          else
            increment(stat_name)
          end
        end
      end
  end
end

Hector.statsd = Hector::StatsdService.new("Statsd")
