class Adva::Admin::SectionsController < Adva::Admin::BaseController
  def new
  end

  def create
    @section = site.sections.create!(params[:adva_section])
    redirect_to edit_adva_admin_site_section_path(site, @section)
  end

  def edit
    @section = site.sections.find(params[:id])
  end

  protected

    def site
      @site ||= Adva::Site.find(params[:site_id])
    end
    helper_method :site

    def section
      @section ||= params[:id] ? site.sections.find(params[:id]) : site.sections.build
    end
    helper_method :section
end