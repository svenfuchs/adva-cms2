module Adva
  module View
    class Tabs < Array
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

      def tab(name, &block)
        tab = detect { |tab| tab.name == name }
        self << tab = Tab.new(self, name) unless tab
        tab.blocks << block
      end
    end
  end
end
