require 'adva/controller/internal_redirect'
require 'inherited_resources'
require 'inherited_resources/helpers'

class Admin::BaseController < InheritedResources::Base
  include UrlHelper

  respond_to :html
  layout 'admin'

  helper_method :tabs

  def self.responder
    Adva::Responder
  end

  def tabs
    @tabs ||= Adva::View::Tabs.new
  end
end
