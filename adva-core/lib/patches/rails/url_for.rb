require 'gem_patching'

# remove trailing segments '.1' and  query params '?=1' from url
Gem.patching('rails', '3.0.0.rc2') do
  ActionDispatch::Routing::RouteSet.class_eval do
    def url_for_with_singleton_resource_patch(options)
      url_for_without_singleton_resource_patch(options).
        sub(/\.\d+(\Z|\?)/) { $1 || '' }.
        sub(/\?=\d+$/, '')
    end
    alias_method_chain :url_for, :singleton_resource_patch
  end
end