require 'adva/internal_redirect'
require 'inherited_resources'

class Admin::BaseController < InheritedResources::Base
  include Adva::InternalRedirect
  
  before_filter :authenticate_user!

  respond_to :html
  layout 'admin'

  helper_method :resources, :site, :public_url_for

  def self.responder
    Adva::Responder
  end

  def resource
    super
  rescue ActiveRecord::RecordNotFound
    build_resource
  end

  def resources
    with_chain(resource)
  end
  
  def site
    @site ||= if params[:site_id]
      Site.find(params[:site_id])
    elsif controller_name == "site"
      Site.find(params[:id]) rescue nil
    end
  end

  def public_url_for(site, resources)
    resources -= [:admin, site]
    resources.empty? ? "http://#{site.host}" : polymorphic_url(resources, :host => site.host)
  end

  def with_chain(object)
    super.unshift(:admin)
  end
end