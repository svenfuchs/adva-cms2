require 'adva/views/menu'

class Admin::Sites::Menu < Adva::Views::Menu
  def to_html
    div :id => 'actions' do
      ul :class => 'menu left' do
        left
      end
      ul :class => 'menu right' do
        right
      end
    end
  end
  
  def left
    li
  end
  
  def right
    item(:'.new', new_admin_site_path)
    if resource.try(:persisted?)
      item(:'.delete', url_for(resources), :method => :delete)
    end
  end
end