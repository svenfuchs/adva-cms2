class SectionsController < BaseController
  helper_method :section
  
  protected

    def _prefix
      case params[:action]
      when 'index'
        'sections'
      else
        resource.type.underscore.pluralize
      end
    end
end