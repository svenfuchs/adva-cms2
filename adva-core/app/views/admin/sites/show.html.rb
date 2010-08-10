# TODO remove named_route helpers and use url_for
class Admin::Sites::Show < Minimal::Template
  def to_html
    ul do
      li { link_to(:'.sections', url_for(resources.push(:sections))) }
      li { link_to(:'.section.new', url_for(resources.unshift(:new).push(:section))) }
      li { link_to(:'.site.new', url_for(resources.unshift(:new))) }
    end
  end
end