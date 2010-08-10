class Admin::Pages::Edit < Minimal::Template
  def to_html
    h2 :'.title'
    render 'form'
    p { button_to("Delete", resources, :method => :delete) }
  end
end