class Admin::ArticlesController < Admin::BaseController
  nested_belongs_to :site, :section, :singleton => true
  
  def index
    redirect_to [:admin, resource.section.site, resource.section]
  end
end