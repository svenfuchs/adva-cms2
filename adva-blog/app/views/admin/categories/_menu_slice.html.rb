require_dependency 'admin/categories/_menu.html'

Admin::Categories::Menu.class_eval do
  include do
    def main
      super
      posts if blog?
    end

    protected

      def posts
        item(:'.posts', index_parent_path(:posts), :before => :'.index')
      end

      def blog?
        resource.section.is_a?(Blog)
      end
  end
end


