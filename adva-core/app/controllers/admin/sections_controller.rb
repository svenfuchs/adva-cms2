class Admin::SectionsController < Admin::BaseController
  belongs_to :site

  helper :sections

  def create
    resource.save
    respond_with *resources << resource.article
  end
end