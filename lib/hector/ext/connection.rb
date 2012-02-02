module Hector
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
end
