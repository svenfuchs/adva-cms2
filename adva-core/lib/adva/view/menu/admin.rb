# Base class for admin menus. Encapsulates assumptions made by the admin layout.

module Adva
  module View
    class Menu
      class Admin < Menu
        def self.id(id)
          write_inheritable_attribute(:id, id)
        end

        class Actions < Admin
          id :actions
        end

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

        protected

          def id
            self.class.read_inheritable_attribute(:id)
          end

          def persisted?
            resource.try(:persisted?)
          end
      end
    end
  end
end