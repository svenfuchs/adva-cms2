class Admin::PostsController < Admin::BaseController
  nested_belongs_to :site, :blog
  purges :create, :update, :destroy
end