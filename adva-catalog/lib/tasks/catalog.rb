require 'rails/generators'

# TODO dry this up with adva/core/tasks

module Adva
  class Catalog
    class Tasks < Rails::Generators::Base
      namespace 'adva:cms'
      source_root Adva::Catalog.root
      def install
        Dir[Adva::Catalog.root.join('db/migrate/*')].each do |source|
          copy_file(source.gsub(Adva::Catalog.root.to_s, '.'))
        end
      end
    end
  end
end

namespace :adva do
  desc 'Install adva-catalog'
  task :install do
    Adva::Catalog::Tasks.new.install
  end
end