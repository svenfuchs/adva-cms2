require_dependency 'admin/sections/_menu.html'

class Admin::Pages::Menu < Admin::Sections::Menu
  include do
    def right
      super
      destroy if show?
    end
  end
end
