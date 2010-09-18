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
      params[:site][:sections_attributes] ||= [{ :type => 'Page' }]
    end
    
    def protect_install
      if Account.first
        flash[:error] = t(:'flash.installation.protected')
        redirect_to admin_sites_url
      end
    end
end
