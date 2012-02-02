module Hector
  class StatsdService < Service
    attr_accessor :client, :namespace
    
    def track(stat_name, event_name, pattern = nil)
      intercepts_for(event_name.to_sym) << [stat_name, pattern]
    end
    
    def increment(name)
      Hector.defer do
        client.increment(normalize_stat_name(name)) if client.respond_to?(:increment)
      end
    end
    
    def decrement(name)
      Hector.defer do
        client.decrement(normalize_stat_name(name)) if client.respond_to?(:decrement)
      end
    end
    
    def normalize_stat_name(name)
      name = "#{namespace.chomp(".")}.#{name}" if namespace
      name
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
