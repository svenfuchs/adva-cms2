class Admin::Blogs::New < Minimal::Template
  def to_html
    h2 :'.title'
    render 'admin/sections/select_type'
    render :partial => 'form'
  end
end