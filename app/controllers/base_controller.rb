require 'inherited_resources'

class BaseController < InheritedResources::Base
  class << self
    def responder
      Adva::Responder
    end
  end
  
  def current_site
    Site.first # TODO
  end
end