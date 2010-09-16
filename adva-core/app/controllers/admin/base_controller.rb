require 'adva/controller/internal_redirect'
require 'inherited_resources'
require 'inherited_resources/helpers'

class Admin::BaseController < InheritedResources::Base
  include UrlHelper

  respond_to :html
  layout 'admin'

  helper_method :account, :sidebar
  delegate :account, :to => :site

  def self.responder
    Adva::Responder
  end

  def sidebar
    @sidebar ||= Adva::View::Tabs.new
  end
end