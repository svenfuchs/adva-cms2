require_dependency 'url_helper'

UrlHelper.module_eval do
  include do
    def public_url_for(resources, options = {})
      reject = lambda { |resource| resource.is_a?(Category) }
      rejected = resources.select(&reject)
      rejected.map! { |resource| [resource.class.name.foreign_key, resource.id] }

      resources.reject!(&reject)
      options.merge!(Hash[*rejected.flatten])
      super
    end
  end
end

