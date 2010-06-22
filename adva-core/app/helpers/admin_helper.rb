module AdminHelper
  def public_url_for(site, resources)
    resources -= [:admin, site]
    resources << :root if resources.empty?
    polymorphic_url(resources, :host => site.host)
  end
end