class Admin::SitesController < Admin::BaseController
  helper :sections
  helper_method :resources, :site
  
  def index
  end

  def new
  end
    
  def show
  end
  
  def create
    site.save
    respond_with *resources
  end
  
  protected
  
    def resources
      [:admin, site]
    end
  
    def site
      @site ||= params[:id] ? Site.find(params[:id]) : 
        Site.new(params[:site] || { :host => request.host, :sections_attributes => [{ :title => '' }] })
    end
end