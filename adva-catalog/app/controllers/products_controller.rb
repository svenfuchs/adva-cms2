class ProductsController < BaseController
  nested_belongs_to :section

  attr_reader :section
  helper_method :section # TODO extend inherited_resources to always define these?
end