module Adva
  class Registry < Hash
    class << self
      def instance
        @@instance ||= new
      end
    
      def get(*args)
        instance.get(*args)
      end
    
      def set(*args)
        instance.set(*args)
      end
    
      def clear
        instance.clear
      end
    end

    def initialize
      super &lambda { |hash, key| hash[key] = Registry.new }
    end

    def set(*args)
      value, last_key = args.pop, args.pop.to_sym
      target = args.inject(self) { |result, key| result[key.to_sym] }

      if value.is_a?(Hash)
        target[last_key].merge!(to_registry(value))
      else
        target.merge!(last_key => value)
      end
    end

    def get(*keys)
      keys.map { |key| key.to_sym }.inject(self) do |result, key| 
        return nil unless result.has_key?(key)
        result[key]
      end
    end
  
    protected
    
      def merge!(other)
        other.each { |key, value| self[key] = value }
      end
  
      def to_registry(hash)
        hash.inject(Registry.new) do |registry, (key, value)|
          registry[key.to_sym] = value.is_a?(Hash) ? to_registry(value) : value
          registry
        end
      end
  end
end