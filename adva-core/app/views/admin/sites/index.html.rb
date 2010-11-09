class Admin::Sites::Index < Minimal::Template
  include do
    def to_html
      h2 :'.title'
      ul do
        collection.each do |site| # TODO [tests] make sure collection is scoped to account
          li { link_to(site.name, [:admin, site]) }
        end
      end
    end
  end
end
