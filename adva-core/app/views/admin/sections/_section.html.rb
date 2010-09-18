class Admin::Sections::Section < Minimal::Template
  include do
    def to_html
      p { link_to(section.name, [:admin, section.site, section]) }
    end
  end
end