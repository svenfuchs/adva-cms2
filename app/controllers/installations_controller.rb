class InstallationsController < BaseController
  layout 'login'

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
    # TODO create a superuser
    site = Site.create(params[:site])
    respond_with site
  end

  protected
    def site
      @site ||= Site.new(:sections_attributes => [{ :title => t(:'adva.sites.install.section_default', :default => 'Home') }])
    end

    def normalize_install_params
      params[:site] ||= {}
      params[:site].merge!(:host => request.host_with_port)
      params[:site][:title] ||= params[:site][:name]
    end
end
