class Adva::Admin::SitesController < Adva::Admin::BaseController
  def show
  end
  
  def site
    @site ||= Adva::Site.find(params[:id])
  end
  helper_method :site
end