class PostsController < BaseController
  nested_belongs_to :section
end