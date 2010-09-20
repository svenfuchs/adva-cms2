module Layouts
  class Flash < Minimal::Template
    def to_html
      controller.flash.each do |name, value|
        p value, :id => "flash_#{name}", :class => "flash #{name}"
      end
    end
  end
end