module Adva
  module View
    class Tabs < Array
      autoload :Tab, 'adva/view/tabs/tab'

      def tab(name, &block)
        unless tab = detect { |tab| tab.name == name }
          self << tab = Tab.new(self, name)
        end
        tab.blocks << block
      end
    end
  end
end