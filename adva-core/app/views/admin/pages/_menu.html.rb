class Admin::Pages::Menu < Minimal::Template
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
    if resource.try(:persisted?)
      li { h4 "#{resource.title}:" }
      li { link_to(:'.edit', url_for(resources.unshift(:edit))) }
      # li { link_to(:'.edit', url_for(resources.unshift(:settings))) }
    end
  end
  
  def right
    if resource.try(:persisted?)
      li { link_to(:'.delete', url_for(resources), :method => :delete) }
    end
  end
end