class ArticlesController < BaseController
  belongs_to :section, :singleton => true
end