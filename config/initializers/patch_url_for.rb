raise 'patch for Rails beta 3' if Gem.loaded_specs['rails'].version.to_s > '3.0.0.beta3'

ActionDispatch::Routing::RouteSet.class_eval do
  def url_for_with_singleton_resource_patch(options)
    url = url_for_without_singleton_resource_patch(options)
    url.sub(/\.\d+\Z/, '') # remove trailing '.1' from url
  end
  alias_method_chain :url_for, :singleton_resource_patch
end