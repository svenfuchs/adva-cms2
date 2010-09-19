module Adva
  module View
    class Form
      module Sidebar
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
                ul do
                  controller.sidebar.each do |tab|
                    li(:class => tab.active? ? :active : '') do
                      link_to(:"admin.sidebar.tabs.#{tab.name}", "##{tab.name}")
                    end
                  end
                end
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
end