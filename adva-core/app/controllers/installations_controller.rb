class InstallationsController < BaseController
  defaults :resource_class => Site
  # defaults :resource_class => Site, :collection_name => 'sites', :instance_name => 'site'
  # belongs_to :account
  
  layout 'simple'

  respond_to :html

  helper :sections
  helper_method :resources, :site

  before_filter :normalize_install_params, :only => :create

  # include CacheableFlash
  # helper :base

  # before_filter :protect_install, :except => :confirmation
  # filter_parameter_logging :password
  #
  # layout 'simple'
  # renders_with_error_proc :below_field

  def new
  end

  def create
    account = Account.create!(params[:account])
    site = account.sites.create!(params[:site])

    # TODO sign the in, redirect to admin/sites/1

    respond_with site
  end

  protected
    def resources
      [:admin, site]
    end
  
    def site
      @site ||= Site.new(:sections_attributes => [{ 
        :title => t(:'adva.sites.install.section_default', :default => 'Home') 
      }])
    end

    def normalize_install_params
      params[:account] ||= {}
      params[:site] ||= {}
      params[:site].merge!(:host => request.host_with_port)
      params[:site][:title] ||= params[:site][:name]
    end
end
