class Admin::Categories::Menu < Adva::View::Menu::Admin::Actions
  include do
    def main
      parent_resource_label
      index
      edit_parent
    end

    def right
      collection? ? new : destroy
      reorder if index? && collection.size > 1
    end

    protected

      def reorder
        super( :'data-resource_type' => 'section', :'data-sortable_type' => 'categories')
      end
  end
end

