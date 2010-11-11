require_dependency 'url_helper'

UrlHelper.module_eval do
  include do
    def public_url_for(resources, options = {})
      options[:category_id] = resources.pop.id if resources.last.class.name == 'Category'
      super
    end
  end
end

