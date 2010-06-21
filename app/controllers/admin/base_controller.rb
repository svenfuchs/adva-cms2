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
    super
  rescue ActiveRecord::RecordNotFound
    build_resource
  end

  def resources
    with_chain(resource)
  end

  def with_chain(object)
    super.unshift(:admin)
  end
end