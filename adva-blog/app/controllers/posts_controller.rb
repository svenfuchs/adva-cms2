class PostsController < BaseController
  nested_belongs_to :blog
  before_filter :set_id, :only => :show

  protected

    def set_id
      args = *params.values_at(:year, :month, :day, :slug)
      params[:id] = Post.by_permalink(*args).first.try(:id)
    end
end