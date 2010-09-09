module Adva
  module Views
    class Menu
      class Admin < Menu
        class_inheritable_accessor :id

        class Actions < Admin; self.id = 'actions' end

        def to_html
          div :id => id, :class => 'menus' do
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
end