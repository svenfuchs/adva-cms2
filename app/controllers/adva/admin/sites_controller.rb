class Adva::Admin::SitesController < Adva::Admin::BaseController
  def show
    @current_site = Adva::Site.find(params[:id])
  end
end