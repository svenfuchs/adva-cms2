class Admin::ArticlesController < Admin::BaseController
  nested_belongs_to :site, :section
end