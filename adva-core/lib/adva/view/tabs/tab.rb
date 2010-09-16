module Adva
  module View
    class Tabs
      class Tab
        attr_reader :tabs, :name
      
        def initialize(tabs, name)
          @tabs = tabs
          @name = name
        end
      
        def active?
          self == tabs.first
        end
      
        def blocks
          @blocks ||= []
        end
      end
    end
  end
end