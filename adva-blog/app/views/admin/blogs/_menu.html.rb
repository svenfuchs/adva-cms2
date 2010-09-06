class Admin::Blogs::Menu < Adva::Views::Menu
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
      li { link_to(:'.show', url_for(resources)) }
      li { link_to(:'.edit', url_for(resources.unshift(:edit))) }
    end
  end

  def right
    if resource.try(:persisted?)
      li { link_to(:'.new_item', url_for(resources.unshift(:new).push(:post))) }
      li { link_to(:'.delete', url_for(resources), :method => :delete) }
    end
  end
end