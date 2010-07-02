class Admin::PostsController < Admin::BaseController
  nested_belongs_to :site, :section
end