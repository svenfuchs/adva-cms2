module UrlHelper
  def self.included(base)
    base.send(:helper_method, public_instance_methods(false))
  end

  def public_url
    public_url_for(resources.reject { |r| r.respond_to?(:new_record?) && r.new_record? })
  end

  def public_url_for(resources)
    resources -= [:admin, site]

    # FIXME move this to adva-categories
    reject = lambda { |resource| resource.is_a?(Category) }
    options = Hash[*resources.select(&reject).map { |resource| [resource.class.name.foreign_key, resource.id] }.flatten]
    options.merge(:host => site.host)

    resources.reject!(&reject)
    resources.empty? ? "http://#{site.host}" : polymorphic_url(resources, options)
  end
end
