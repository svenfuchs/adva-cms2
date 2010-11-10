require 'inherited_resources'
require 'inherited_resources/helpers'
require 'simple_table'

class BaseController < InheritedResources::Base
  begin_of_association_chain :site
  tracks :resource, :resources, :collection, :site => %w(.title .name .sections)

  layout 'default'
  helper_method :site

  def self.responder
    Adva::Responder
  end

  def site
    @site ||= Site.by_host(request.host_with_port)
  end
end
