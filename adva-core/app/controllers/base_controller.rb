require 'inherited_resources'

class BaseController < InheritedResources::Base
  class << self
    def responder
      Adva::Responder
    end
  end
  
  layout 'default'
  
  helper_method :current_site, :resources
  
  def current_site
    Site.first # TODO
  end

  def resource
    super
  rescue ActiveRecord::RecordNotFound
    build_resource
  end

  def resources
    with_chain(resource)
  end
end