class Admin::SitesController < Admin::BaseController
  respond_to :html
  respond_to :json, :only => :update

  purges :update, :destroy

  before_filter :set_params_for_nested_resources, :only => [:new, :edit]
  before_filter :set_account, :only => :create

  helper :sections

  protected

    def set_params_for_nested_resources
      params[:site] ||= { :host => request.host, :sections_attributes => [{ :name => '' }] }
    end

    def set_account
      params[:site][:account_id] = Account.first.id # TODO figure out how we want to do this
    end
end
