class ProductsController < BaseController
  nested_belongs_to :catalog

  before_filter :set_id, :only => :show

  attr_reader :catalog
  helper_method :catalog # TODO extend inherited_resources to always define these?

  protected

    def set_id
      params[:id] = Product.where(:slug => params[:slug]).first.try(:id)
    end
end