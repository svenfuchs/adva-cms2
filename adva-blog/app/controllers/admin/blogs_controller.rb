class Admin::BlogsController < Admin::SectionsController
  purges :create, :update, :destroy

  def show
    # TODO needs to be here because the admin top section drop down menu links to section#show.
    # might want to invent a concept of default_action for a section type or something else.
    internal_redirect_to 'admin/posts#index', params.merge(:blog_id => params.delete(:id))
  end
end
