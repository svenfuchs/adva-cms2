# TODO remove named_route helpers and use url_for
module Admin
  module Sites
    class Show < Minimal::Template
      def to_html
        ul do
          li link_to(t(:'.sections'), url_for(resources.push(:sections)))
          li link_to(t(:'.section.new'), url_for(resources.unshift(:new).push(:section)))
          li link_to(t(:'.site.new'), url_for(resources.unshift(:new)))
        end
      end
    end
  end
end