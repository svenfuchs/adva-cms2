class Admin::SectionsController < Admin::BaseController
  belongs_to :site

  respond_to :html
  respond_to :json, :only => :update

  before_filter :protect_last_section, :only => :destroy

  helper :sections
  abstract_actions :except => [:index, :destroy]

  purges :destroy

  protected

    def protect_last_section
      if site.sections.count == 1
        resource.errors[:error] = [:last_section_cant_be_destroyed]
        respond_with(resources)
      end
    end
end
