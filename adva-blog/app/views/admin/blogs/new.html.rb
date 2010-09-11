class Admin::Blogs::New < Minimal::Template
  def to_html
    render :partial => 'admin/sections/select_type'
    h2 :'.title'
    render :partial => 'form'
  end
end