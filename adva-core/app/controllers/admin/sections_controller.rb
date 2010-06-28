class Admin::SectionsController < Admin::BaseController
  belongs_to :site

  before_filter :set_params_for_nested_resources, :only => [:new, :create, :edit, :update]
  before_filter :internal_redirect_to_section_type_controller, :except => :index # :scope => self ???

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

    def internal_redirect_to_section_type_controller
      return unless instance_of?(Admin::SectionsController)
      params[instance_name] = params.delete(:section)
      internal_redirect_to("admin/#{collection_name}##{params[:action]}") # action_name ???
    end

    def _prefix
      params[:action] == 'index' ? 'admin/sections' : "admin/#{collection_name}"
    end
    
    def instance_name
      resource.type.underscore.singularize
    end
    
    def collection_name
      resource.type.underscore.pluralize
    end
end