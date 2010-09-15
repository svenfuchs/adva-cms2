class BlogsController < BaseController
  layout 'blog'
  tracks :resource => :posts
end