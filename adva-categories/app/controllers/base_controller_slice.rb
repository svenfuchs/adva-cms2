require_dependency 'base_controller'

BaseController.class_eval do
  include do
    def collection
      collection = super
      params[:category_id] ? collection.categorized(params[:category_id]) : collection
    end
  end
end
