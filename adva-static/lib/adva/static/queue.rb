module Adva
  class Static
    class Queue < Array
      def push(*elements)
        elements = Array(elements).flatten.uniq
        elements.reject! { |element| seen?(element) }
        seen(elements)
        super
      end
      
      def seen?(element)
        log.include?(element)
      end
      
      def seen(elements)
        @log = log.concat(elements)
        log.uniq!
      end
      
      def log
        @log ||= []
      end
    end
  end
end