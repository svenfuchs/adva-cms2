class Admin::Pages::New < Minimal::Template
  def to_html
    render 'admin/sections/select_type'
    h2 :'.title'
    render 'form'
  end
end