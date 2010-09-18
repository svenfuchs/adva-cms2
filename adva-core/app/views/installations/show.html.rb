class Installations::Show < Minimal::Template
  include do
    def to_html
      h2 :'.title'
      p :'.confirm'
      p { link_to(:'.link_to_admin', admin_site_path(resource)) }
    end
  end
end