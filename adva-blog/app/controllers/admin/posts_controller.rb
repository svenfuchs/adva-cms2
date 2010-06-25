class Admin::PostsController < Admin::BaseController
  nested_belongs_to :site, :section
  
  def index
    redirect_to [:admin, resource.section.site, resource.section]
  end
end