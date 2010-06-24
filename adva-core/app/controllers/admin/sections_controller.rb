class Admin::SectionsController < Admin::BaseController
  belongs_to :site
  before_filter :set_params_for_nested_resources, :only => [:new, :create, :edit, :update]

  helper :sections

  def create
    resource.save
    respond_with *resources
  end

  protected

    def set_params_for_nested_resources
      params[:section] ||= { :type => 'Page' }
      if params[:section][:type] == 'Page'
        params[:section][:article_attributes] ||= { :body => '' }
      else
        params[:section].delete(:article_attributes)
      end
    end
end