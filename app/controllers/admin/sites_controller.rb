class Admin::SitesController < Admin::BaseController
  
  helper :sections
  helper_method :resource, :site
  
  def index
  end

  def new
  end
    
  def show
  end
  
  def create
    site.save
    respond_with *resource
  end
  
  protected
  
    def resource
      [:admin, site]
    end
  
    def site
      @site ||= params[:id] ? Site.find(params[:id]) : 
        Site.new(params[:site] || { :host => request.host, :sections_attributes => [{ :title => '' }] })
    end
end