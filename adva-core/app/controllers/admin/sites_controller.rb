class Admin::SitesController < Admin::BaseController
  purges :update, :destroy

  before_filter :set_params_for_nested_resources, :only => [:new, :edit]
  before_filter :set_account, :only => :create

  helper :sections

  protected

    def set_params_for_nested_resources
      params[:site] ||= { :host => request.host, :sections_attributes => [{ :name => '' }] }
    end

    def set_account
      params[:site][:account_id] = Account.first.id # TODO
    end
end
