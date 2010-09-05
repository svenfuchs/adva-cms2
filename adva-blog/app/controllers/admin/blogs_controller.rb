class Admin::BlogsController < Admin::SectionsController
  purges :create, :update, :destroy
end