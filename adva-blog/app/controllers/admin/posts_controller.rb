class Admin::PostsController < Admin::BaseController
  nested_belongs_to :site, :blog

  def update
    response.headers[Adva::Static::Rack::PURGE_HEADER] = polymorphic_path([resource.section, resource])
    super
  end
end