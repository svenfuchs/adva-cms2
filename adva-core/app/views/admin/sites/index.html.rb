class Admin::Sites::Index < Minimal::Template
  def to_html
    h2 :'.title'
    ul do
      collection.each do |site|
        li { link_to(site.name, [:admin, site]) }
      end
    end
  end
end