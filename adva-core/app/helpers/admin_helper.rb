module AdminHelper
  def public_url_for(site, resources)
    resources -= [:admin, site]
    resources.empty? ? "http://#{site.host}" : polymorphic_url(resources, :host => site.host)
  end
end