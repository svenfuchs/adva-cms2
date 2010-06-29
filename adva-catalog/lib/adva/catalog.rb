require 'adva'

module Adva
  class Catalog < ::Rails::Engine
    rake_tasks do
      require 'adva/catalog/tasks.rb'
    end

    initializer 'adva-catalog.require_section_types' do
      require 'catalog'
    end

    initializer 'adva-catalog.add_catalogs_to_site' do
      Site.has_many :catalogs
    end

    # initializer 'adva-catalog.load_redirects' do
    #   require root.join('config/redirects')
    # end
  end
end