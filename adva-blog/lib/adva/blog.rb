module Adva
  class Blog < ::Rails::Engine
    initializer 'adva-blog.require_section_types' do
      require 'blog'
    end

    initializer 'adva-blog.add_blogs_to_site' do
      Site.has_many :blogs
    end

    initializer 'adva-blog.load_redirects' do
      require root.join('config/redirects')
    end

    # TODO dry up with adva.core.register_middlewares
    # initializer 'adva.blog.register_middlewares' do
    #   urls = ["/stylesheets/adva_blog", "/javascripts/adva_blog", "/images/adva_blog"]
    #   Rails.application.config.middleware.use Rack::Static, :urls => urls, :root => "#{root}/public"
    # end
  end
end