class Admin::Blogs::Edit < Minimal::Template
  def to_html
    h2 t(:'.title')
    render :partial => 'admin/blogs/form'
  end
end