module Adva
  class Blog < ::Rails::Engine
    rake_tasks do
      require 'adva/blog/tasks.rb'
    end

    initializer 'adva.blog.require_section_types' do
      require 'blog'
    end

    # TODO dry up with adva.core.register_middlewares
    # initializer 'adva.blog.register_middlewares' do
    #   urls = ["/stylesheets/adva_blog", "/javascripts/adva_blog", "/images/adva_blog"]
    #   Rails.application.config.middleware.use Rack::Static, :urls => urls, :root => "#{root}/public"
    # end
  end
end