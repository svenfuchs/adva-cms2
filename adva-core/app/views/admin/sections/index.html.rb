class Admin::Sections::Index < Minimal::Template
  def to_html
    h2 :'.title'
    render :partial => 'admin/sections/section', :collection => collection
  end
end