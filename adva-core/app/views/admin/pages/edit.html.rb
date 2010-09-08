class Admin::Pages::Edit < Minimal::Template
  def to_html
    h2 :'.title'
    render 'form'
    p { button_to(:'.delete', resources, :method => :delete) }
  end
end