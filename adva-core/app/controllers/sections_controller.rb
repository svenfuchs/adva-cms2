class SectionsController < BaseController
  helper_method :section
  
  protected

    def site
      current_site
    end

    def section
      @section ||= site.sections.find(params[:id])
    end

    def _prefix
      case params[:action]
      when 'index'
        'sections'
      else
        resource.type.underscore.pluralize
      end
    end
end