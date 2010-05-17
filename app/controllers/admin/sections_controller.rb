class Admin::SectionsController < Admin::BaseController
  respond_to :html
  
  def index
    render :text => "da indexa"
  end

  def new
  end

  def create
    section = params[:section][:type].constantize.create!(params[:section].merge(:site_id => site.id))
    redirect_to [:edit, :admin, site, section, section.article]
  end

  def edit
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
      @section ||= params[:id] ? site.sections.find(params[:id]) : site.sections.build(:type => 'Page')
    end
    helper_method :section
end