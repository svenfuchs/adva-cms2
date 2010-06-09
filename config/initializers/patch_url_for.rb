require 'gem/patching'

Gem.patching('rails', '3.0.0.beta4') do 
  ActionDispatch::Routing::RouteSet.class_eval do
    def url_for_with_singleton_resource_patch(options)
      url = url_for_without_singleton_resource_patch(options)
      url.sub(/\.\d+\Z/, '') # remove trailing '.1' from url
    end
    alias_method_chain :url_for, :singleton_resource_patch
  end
end