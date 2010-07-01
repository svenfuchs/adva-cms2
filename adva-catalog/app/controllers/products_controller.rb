class ProductsController < BaseController
  nested_belongs_to :section
end