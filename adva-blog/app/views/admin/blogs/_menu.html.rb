require_dependency 'admin/sections/_menu.html'

class Admin::Blogs::Menu < Admin::Sections::Menu
  include do
    def main
      super
      categories if persisted? && Adva.engine?(:categories)
    end

    def right
      new_item if persisted?
      super
    end

    protected

      def show
        item(:'.show', index_path(:posts))
      end

      def new_item
        item(:'.new_item', new_path(:post))
      end
  end
end
