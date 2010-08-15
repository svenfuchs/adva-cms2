class Admin::Sites::Index < Minimal::Template
  def to_html
    h2 :'.title'
    collection.each do |site|
      p link_to(site.name, [:admin, site])
    end
  end
end