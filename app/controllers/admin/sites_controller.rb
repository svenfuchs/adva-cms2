class Admin::SitesController < Admin::BaseController
  def show
  end
  
  def site
    @site ||= Site.find(params[:id])
  end
  helper_method :site
end