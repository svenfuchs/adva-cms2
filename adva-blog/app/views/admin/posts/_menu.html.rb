require_dependency 'admin/contents/_menu.html'

class Admin::Posts::Menu < Admin::Contents::Menu
  include do
    def main
      super
      categories(index_parent_path(:categories)) if Adva.engine?(:categories)
    end
  end
end
