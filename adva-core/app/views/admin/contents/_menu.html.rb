class Admin::Contents::Menu < Adva::View::Menu::Admin::Actions
  include do
    def main
      resource_section_label
      index
      edit_parent
    end

    def right
      new
      if persisted?
        edit
        destroy
      end
    end
  end
end
