class Admin::ArticlesController < Admin::BaseController
  respond_to :html
  
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
    helper_method :resource

    def site
      @site ||= Site.find(params[:site_id])
    end
    helper_method :site

    def section
      @section ||= site.sections.find(params[:section_id])
    end
    helper_method :section

    def article
      @article ||= section.article
    end
    helper_method :article
end