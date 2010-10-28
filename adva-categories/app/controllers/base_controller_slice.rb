require_dependency 'base_controller'

BaseController.class_eval do
  include do
    def collection
      params[:category_id] ? super.categorized(params[:category_id]) : super
    end
  end
end
