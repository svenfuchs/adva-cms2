class SectionsController < BaseController
  helper_method :section
  
  def show
  end
  
  protected

    def site
      current_site
    end

    def section
      @section ||= current_site.sections.find(params[:id])
    end
end