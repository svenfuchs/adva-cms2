class Admin::SectionsController < Admin::BaseController
  belongs_to :site

  respond_to :html
  respond_to :json, :only => :update

  before_filter :set_params_for_nested_resources, :only => [:new, :create, :edit, :update]
  before_filter :protect_last_section, :only => :destroy

  helper :sections
  abstract_actions :except => [:index, :destroy]

  purges :destroy

  protected

    def set_params_for_nested_resources
      params[:section] ||= { :type => 'Page' }
      if params[:section][:type] == 'Page'
        # FIXME! [bug] this seems to insert tons of empty articles on update if :article_attributes is empty.
        # shouldn't happen with a regular form submit but still seems a bit ugly
        params[:section][:article_attributes] ||= { :body => '' } if params[:action] == 'new'
      else
        params[:section].delete(:article_attributes)
      end
    end

    def protect_last_section
      if site.sections.count == 1
        resource.errors[:error] = [:last_section_cant_be_destroyed]
        respond_with(resources)
      end
    end
end
