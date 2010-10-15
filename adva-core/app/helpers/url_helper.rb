require 'core_ext/ruby/module/include_anonymous'

module UrlHelper
  def self.included(base)
    base.send(:helper_method, public_instance_methods)
  end

  include do
    def public_url
      public_url_for(resources.reject { |r| r.respond_to?(:new_record?) && r.new_record? })
    end

    def public_url_for(resources, options = {})
      resources -= [:admin, site]
      resources.empty? ? "http://#{site.host}" : polymorphic_url(resources, options)
    end
  end
end
