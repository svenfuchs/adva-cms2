class Admin::PagesController < Admin::SectionsController
  purges :create, :destroy
end