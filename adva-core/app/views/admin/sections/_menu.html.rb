module Admin
  module Sections
    class Menu < Minimal::Template
      def to_html
        div :id => 'actions' do
          ul :class => 'menu left' do
            left
          end
          ul :class => 'menu right' do
            right
          end
        end
      end
  
      def left
      end
  
      def right
      end
    end
  end
end