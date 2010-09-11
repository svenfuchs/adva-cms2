class Admin::Blogs::New < Minimal::Template
  def to_html
    render :partial => 'admin/sections/select_type'
    h2 t(:'.title')
    render :partial => 'admin/blogs/form'
  end
end