require 'inherited_resources'
require 'simple_table'

ActionView::Base.send :include, SimpleTable

class BaseController < InheritedResources::Base
  class << self
    def responder
      Adva::Responder
    end
  end
  
  tracks :resource, :resources, :current_site => %w(.title .name)

  layout 'default'
  helper_method :current_account, :current_site, :resources
  
  def current_account
    Account.first # TODO
  end

  def current_site
    Site.first # TODO
  end

  def resource
    super
  rescue ActiveRecord::RecordNotFound => e
    %w(new create).include?(params[:action]) ? build_resource : raise(e)
  end

  def resources
    with_chain(resource)
  end
end