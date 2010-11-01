class Admin::BlogsController < Admin::SectionsController
  purges :create, :update, :destroy

  def show
    # TODO need to do an internal redirect here because the admin top section drop down menu
    # links to section#show. Might want to invent a concept of default_action for a section
    # type. Also might want to invent a :preserve_flash => true concept or something like that
    # when redirecting through http (which otherwise looses the flash after, e.g. blog#create)
    internal_redirect_to 'admin/posts#index', params.merge(:blog_id => params.delete(:id))
  end
end
