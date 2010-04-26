class Admin::SectionsController < Admin::BaseController
  
  respond_to :html
  
  def index
    render :text => "da indexa"
  end

  def new
  end

  def create
    @section = site.sections.create!(params[:section])
    redirect_to edit_admin_site_section_path(site, @section)
  end

  def edit
    @section = site.sections.find(params[:id])
  end

  def update
    section.update_attributes!(params[:section])
    redirect_to edit_admin_site_section_path(site, section)
  end

  def destroy
    section.destroy
    redirect_to :action => :index
  end

  protected

    def site
      @site ||= Site.find(params[:site_id])
    end
    helper_method :site

    def section
      @section ||= params[:id] ? site.sections.find(params[:id]) : site.sections.build
    end
    helper_method :section
end