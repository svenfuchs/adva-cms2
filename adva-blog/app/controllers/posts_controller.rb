class PostsController < BaseController
  nested_belongs_to :blog
  before_filter :set_id, :only => :show

  protected

    def set_id
      blog = current_site.blogs.find(params[:blog_id])
      permalink = params.values_at(:year, :month, :day, :slug)
      params[:id] = blog.posts.by_permalink(*permalink).first.try(:id)
    end
end