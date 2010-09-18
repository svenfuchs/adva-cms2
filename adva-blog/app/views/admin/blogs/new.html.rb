class Admin::Blogs::New < Minimal::Template
  include do
    def to_html
      h2 :'.title'
      render 'admin/sections/select_type'
      render :partial => 'form'
    end
  end
end