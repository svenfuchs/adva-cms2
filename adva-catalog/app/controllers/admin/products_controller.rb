class Admin::ProductsController < Admin::BaseController
  nested_belongs_to :site, :catalog
end