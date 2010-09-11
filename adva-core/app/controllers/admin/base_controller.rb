require 'adva/internal_redirect'
require 'inherited_resources'
require 'inherited_resources/helpers'

class Admin::BaseController < InheritedResources::Base
  include InheritedResources::Helpers::Resources
  include InheritedResources::Helpers::UrlFor
  include Adva::InternalRedirect

  respond_to :html
  layout 'admin'

  delegate :account, :to => :site

  helper_method :account, :public_url, :public_url_for

  def self.responder
    Adva::Responder
  end
  
  def public_url
    public_url_for(resources)
  end

  def public_url_for(resources)
    resources -= [:admin, site]
    resources.empty? ? "http://#{site.host}" : polymorphic_url(resources, :host => site.host)
  end
end