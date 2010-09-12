module UrlHelper  
  def self.included(base)
    base.send(:helper_method, public_instance_methods(false))
  end

  def public_url
    public_url_for(resources.reject { |r| r.respond_to?(:new_record?) && r.new_record? })
  end

  def public_url_for(resources)
    resources -= [:admin, site]
    resources.empty? ? "http://#{site.host}" : polymorphic_url(resources, :host => site.host)
  end
end