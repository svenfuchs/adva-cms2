class Admin::PagesController < Admin::SectionsController
  def update
    response.headers[Adva::Static::Rack::PURGE_HEADER] = polymorphic_path([resource])
    super
  end
end