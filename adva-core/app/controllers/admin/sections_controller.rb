class Admin::SectionsController < Admin::BaseController
  belongs_to :site
  before_filter :set_params_for_nested_resources, :only => [:new, :create, :edit, :update]

  helper :sections
  
  def show
    if resource.is_a?(Page)
      redirect_to resources.unshift(:edit).push(resource.article)
    else
      super
    end
  end

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

    def _prefix
      case params[:action]
      when 'index'
        'admin/sections'
      else
        "admin/#{resource.type.underscore.pluralize}"
      end
    end
end