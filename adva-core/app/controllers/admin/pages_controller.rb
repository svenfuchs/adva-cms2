class Admin::PagesController < Admin::SectionsController
  purges :create, :update, :destroy
  
  def update
    update! do |success, failure|
      failure.html { render :show }
    end
  end
end