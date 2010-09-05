class Admin::Sites::Menu < Minimal::Template
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
    li { link_to(:'.new', new_admin_site_path) }
    if resource.try(:persisted?)
      li { link_to(:'.delete', url_for(resources), :method => :delete) }
    end
  end
end