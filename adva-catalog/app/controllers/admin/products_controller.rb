class Admin::ProductsController < Admin::BaseController
  nested_belongs_to :site, :section
  
  def index
    redirect_to resources[0..-2]
  end
end