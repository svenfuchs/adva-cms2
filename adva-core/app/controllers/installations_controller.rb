class InstallationsController < BaseController
  defaults :resource_class => Site, :instance_name => 'site'

  layout 'simple'
  helper :sections

  before_filter :set_params_for_nested_resources, :only => [:new, :create]
  before_filter :protect_install,  :only => [:new, :create]

  def create
    @site = Site.install(params)
    respond_with resource
  end

  protected
    def set_params_for_nested_resources
      params[:site] ||= {}
      params[:site].reverse_merge!(:host => request.host_with_port, :title => params[:site][:name], :account_attributes => {})
      params[:site][:sections_attributes] ||= [{ :type => 'Page', :name => I18n.t(:'section.default_name', :default => 'Home') }]
    end

    def protect_install
      if Site.by_host(request.host_with_port)
        flash[:error] = t(:'flash.installation.protected', :host => request.host_with_port)
        # redirect_to admin_sites_url # TODO [user dependency] figure out how to remove the user dependency
      end
    end
end
