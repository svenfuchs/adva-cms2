module Adva
  module View
    class Form
      module Tabs
        def form_for(*args, &block)
          super(*args, &with_tabs(block))
        end

        def simple_form_for(*args, &block)
          super(*args, &with_tabs(block))
        end

        def with_tabs(block)
          if respond_to?(:sidebar)
            lambda do |*args|
              block.call(*args)
              sidebar

              div :class => :tabs do
                ul do
                  controller.tabs.each do |tab|
                    li(:class => tab.active? ? :active : '') do
                      link_to(:"admin.tabs.#{tab.name}", "##{tab.name}")
                    end
                  end
                end
                controller.tabs.each do |tab|
                  div :id => "tab_#{tab.name}", :class => "tab #{tab.active? ? :active : ''}" do
                    tab.blocks.each { |block| block.call }
                  end
                end
              end
            end
          else
            block
          end
        end

        # should store the tabs on the form builder object instead of the controller
        def tab(*args, &block)
          controller.tabs.tab(*args, &block)
        end
      end
    end
  end
end
