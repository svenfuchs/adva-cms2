class Admin::SectionsController < Admin::BaseController
  belongs_to :site
  before_filter :set_params_for_nested_resources, :only => [:new, :edit]

  helper :sections

  def create
    resource.save
    respond_with *resources
  end

  protected

    def set_params_for_nested_resources
      params[:section] ||= { :type => 'Page', :article_attributes => { :body => '' } }
    end
end