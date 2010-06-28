class Admin::PagesController < Admin::SectionsController
  def show
    redirect_to resources.unshift(:edit).push(resource.article)
  end
end