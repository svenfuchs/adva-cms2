class Admin::PagesController < Admin::SectionsController
  purges :create, :update, :destroy
end