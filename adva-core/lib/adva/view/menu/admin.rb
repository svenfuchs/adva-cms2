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

        def build
          div :id => id, :class => 'menus' do
            ul :class => 'menu main' do
              main
              render_items
            end
            ul :class => 'menu right' do
              right
              render_items
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

          def resource_label
            label("#{resource.name}:")
          end

          def resource_section_label
            label("#{resource.section.name}:")
          end

          def parent_resource_label
            label("#{parent_resource.name}:")
          end

          def index
            item(:'.index', index_path)
          end

          def show
            item(:'.show', show_path)
          end

          def edit
            item(:'.edit', edit_path)
          end

          def edit_parent
            item(:'.edit_parent', edit_parent_path)
          end

          def categories(url = nil, options = { :after => :'.show' })
            url ||= index_path(:categories)
            item(:'.categories', url, options)
          end

          def new
            item(:'.new', new_path)
          end

          def reorder
            item(:'.reorder', index_path, :activate => false)
          end

          def destroy
            item(:'.destroy', resource_path, :method => :delete, :confirm => t(:'.confirm_destroy', :model_name => resource.class.model_name.human))
          end

          def persisted?
            resource.try(:persisted?)
          end

          def collection?
            index? || new? || create?
          end

          %w(index show new create edit update).each do |action|
            define_method(:"#{action}?") do
              params[:action] == action
            end
          end
      end
    end
  end
end
