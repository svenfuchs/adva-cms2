require 'inherited_resources'
require 'inherited_resources/helpers'
require 'simple_table'

ActionView::Base.send :include, SimpleTable

class BaseController < InheritedResources::Base
  class << self
    def responder
      Adva::Responder
    end
  end
  
  tracks :resource, :resources, :site => %w(.title .name)

  layout 'default'
  helper_method :account, :site
  delegate :account, :to => :site

  def site
    Site.first # TODO
  end
end