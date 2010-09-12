class Admin::SectionsController < Admin::BaseController
  belongs_to :site

  before_filter :set_params_for_nested_resources, :only => [:new, :create, :edit, :update]

  helper :sections
  abstract_actions :except => :index

  def create
    resource.save
    respond_with *resources
  end

  protected

    def set_params_for_nested_resources
      params[:section] ||= { :type => 'Page' }
      if params[:section][:type] == 'Page'
        # FIXME! this seems to insert tons of empty articles on update if :article_attributes is empty.
        # shouldn't happen with a regular form submit but still seems a bit ugly
        params[:section][:article_attributes] ||= { :body => '' }
      else
        params[:section].delete(:article_attributes)
      end
    end
end