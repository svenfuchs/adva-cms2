require 'inherited_resources'

class BaseController < InheritedResources::Base
  class << self
    def responder
      Adva::Responder
    end
  end
  
  layout 'default'
  
  helper_method :current_site
  
  def current_site
    Site.first # TODO
  end
end