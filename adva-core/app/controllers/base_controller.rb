require 'inherited_resources'

class BaseController < InheritedResources::Base
  class << self
    def responder
      Adva::Responder
    end
  end
  
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
    params[:action] == 'new' ? build_resource : raise(e)
  end

  def resources
    with_chain(resource)
  end
end