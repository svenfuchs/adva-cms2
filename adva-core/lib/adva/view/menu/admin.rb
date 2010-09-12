# Base class for admin menus. Encapsulates assumptions made by the admin layout.

module Adva
  module View
    class Menu
      class Admin < Menu
        class_inheritable_accessor :id

        class Actions < Admin; self.id = 'actions' end

        def to_html
          div :id => id, :class => 'menus' do
            ul :class => 'menu main' do
              main
            end
            ul :class => 'menu right' do
              right
            end
          end
        end

        def main
        end

        def right
        end
      end
    end
  end
end