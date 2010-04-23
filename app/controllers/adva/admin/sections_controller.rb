class Adva::Admin::SectionsController < Adva::Admin::BaseController
  def new
  end
  
  def site
    @site ||= Adva::Site.find(params[:site_id])
  end
  helper_method :site

  def section
    @section ||= params[:id] ? site.sections.find(params[:id]) : site.sections.build
  end
  helper_method :section
end