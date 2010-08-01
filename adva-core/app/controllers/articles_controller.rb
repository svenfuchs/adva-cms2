class ArticlesController < BaseController
  belongs_to :page, :singleton => true
end