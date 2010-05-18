class Admin::ArticlesController < Admin::BaseController
  respond_to :html
  
  helper_method :resource, :site, :section, :article
  
  def index
  end

  def edit
  end

  def update
    article.update_attributes!(params[:article])
    redirect_to resource(:edit)
  end

  protected
  
    def resource(action = nil)
      [:admin, site, section, article].tap { |r| r.unshift(action) if action }
    end

    def site
      @site ||= Site.find(params[:site_id])
    end

    def section
      @section ||= site.sections.find(params[:section_id])
    end

    def article
      @article ||= section.article
    end
end