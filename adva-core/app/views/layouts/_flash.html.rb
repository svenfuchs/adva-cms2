module Layouts
  class Flash < Minimal::Template
    def to_html
      controller.flash.each do |name, value|
        div(value, :id => "flash_#{name}", :class => "flash #{name}")
      end
    end
  end
end