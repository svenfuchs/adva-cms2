module Admin
  module Sections
    class Section < Minimal::Template
      def to_html
        p link_to(section.title, [:admin, section.site, section])
      end
    end
  end
end