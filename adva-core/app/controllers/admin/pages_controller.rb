class Admin::PagesController < Admin::SectionsController
  purges :create, :update

  def update
    update! { |success, failure| failure.html { render :show } }
  end
end
