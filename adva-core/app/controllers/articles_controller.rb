class ArticlesController < BaseController
  belongs_to :section, :singleton => true
  
  def show
    redirect_to resource.section
  end
end