class Admin::Categories::Menu < Adva::View::Menu::Admin::Actions
  include do
    def main
      parent_resource_label
      index
      edit_parent
    end

    def right
      new
      persisted? ? destroy : reorder
    end
  end
end

