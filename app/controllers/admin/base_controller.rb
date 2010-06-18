require 'inherited_resources'

class Admin::BaseController < InheritedResources::Base
  before_filter :authenticate_user!

  respond_to :html
  layout 'admin'

  helper_method :resources

  def self.responder
    Adva::Responder
  end

  def resource
    super rescue build_resource # resource_class.new
  end

  def resources
    with_chain(resource)
  end

  # TODO check for problems in inherited_resources
  def with_chain(object)
    super.unshift(:admin)
  end
end