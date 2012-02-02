module Hector
  class Connection
    def post_init_with_statsd(*args)
      Hector.statsd.increment("connections") if Hector.statsd
      post_init_without_statsd(*args)
    end
    alias_method :post_init_without_statsd, :post_init
    alias_method :post_init, :post_init_with_statsd
    
    def unbind_with_statsd(*args)
      Hector.statsd.decrement("connections") if Hector.statsd
      unbind_without_statsd(*args)
    end
    alias_method :unbind_without_statsd, :unbind
    alias_method :unbind, :unbind_with_statsd
    
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
  
  class SSLConnection
    def post_init_with_statsd_ssl(*args)
      Hector.statsd.increment("connections") if Hector.statsd
      Hector.statsd.increment("ssl_connections") if Hector.statsd
      post_init_without_statsd_ssl(*args)
    end
    alias_method :post_init_without_statsd_ssl, :post_init
    alias_method :post_init, :post_init_with_statsd_ssl
    
    def unbind_with_statsd_ssl(*args)
      # Hector::Connection's unbind will be called by itself
      Hector.statsd.decrement("ssl_connections") if Hector.statsd
      unbind_without_statsd_ssl(*args)
    end
    alias_method :unbind_without_statsd_ssl, :unbind
    alias_method :unbind, :unbind_with_statsd_ssl
  end
end
