class Admin::Categories::Menu < Adva::View::Menu::Admin::Actions
  include do
    def main
      parent_resource_label
      index
      edit_parent
    end

    def right
      collection? ? new : destroy
      reorder if index? # TODO should only happen if we actually have more than 1 category
    end
  end
end

