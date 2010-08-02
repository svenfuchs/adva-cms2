class Admin::PostsController < Admin::BaseController
  nested_belongs_to :site, :blog
end