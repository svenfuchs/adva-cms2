class Admin::PostsController < Admin::BaseController
  nested_belongs_to :site, :blog
  purges :create, :update, :destroy

  # FIXME!!
  def update
    response.headers[Adva::Static::Rack::PURGE_HEADER] = polymorphic_path([resource.section, resource])
    super
  end
end