class Admin::SitesController < Admin::BaseController
  respond_to :html
  respond_to :json, :only => :update

  purges :update, :destroy

  before_filter :set_params_for_nested_resources, :only => [:new, :edit]

  helper :sections

  protected

    def set_params_for_nested_resources
      params[:site] ||= { :host => request.host, :sections_attributes => [{ :name => '' }] }
    end
end
