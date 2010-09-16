module Adva
  module View
    class Form < Minimal::Template
      def form_for(*args, &block)
        super(*args, &with_sidebar_rendering(block))
      end
  
      def simple_form_for(*args, &block)
        super(*args, &with_sidebar_rendering(block))
      end
  
      def with_sidebar_rendering(block)
        if respond_to?(:sidebar)
          lambda do |*args|
            block.call(*args)
            sidebar
            div :class => :tabs do
              controller.sidebar.each do |tab|
                div :id => tab.name, :class => "tab #{tab.active? ? :active : ''}" do
                  tab.blocks.each { |block| block.call }
                end
              end
            end
          end
        else
          block
        end
      end
  
      def tab(*args, &block)
        controller.sidebar.tab(*args, &block)
      end
    end
  end
end