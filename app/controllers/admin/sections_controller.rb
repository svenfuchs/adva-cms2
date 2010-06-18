class Admin::SectionsController < Admin::BaseController
  belongs_to :site

  helper :sections

  def show
    redirect_to :action => :edit # TODO TMP!
  end

  def create
    @section = params[:section][:type].constantize.create(params[:section].merge(:site_id => params[:site_id]))
    respond_with *resources << resource.article
  end
end