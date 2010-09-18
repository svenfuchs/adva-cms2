class Admin::Posts::New < Minimal::Template
  include do
    def to_html
      h2 :'.title'
      render :partial => 'form'
    end
  end
end