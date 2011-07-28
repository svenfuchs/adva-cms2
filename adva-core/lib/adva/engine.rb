# Common behaviour that we want included in all adva engines

require 'active_support/concern'
module Adva
  module Engine
    extend ActiveSupport::Concern

    included do
      config.autoload_paths << paths.app.views.to_a.first
      paths.lib.tasks = Dir[root.join('lib/adva/tasks/*.*')]

      engine_name = name.underscore.split('/').last

      initializer "adva-#{engine_name}.require_patches" do |app|
        require_patches
      end

      initializer "adva-#{engine_name}.load_redirects" do |app|
        load_redirects
      end
    end

    module InstanceMethods
      def require_patches
        Dir[root.join('lib/patches/**/*.rb')].each { |patch| require patch }
      end

      def load_redirects
        begin
          load root.join('config/redirects.rb')
        rescue LoadError
        end
      end

      def copy_migrations
        Dir[root.join('db/migrate/*')].map do |source|
          target = File.expand_path(source.gsub(root.to_s, '.'))
          FileUtils.mkdir_p(File.dirname(target))
          FileUtils.cp(source, target)
          target
        end
      end
    end
  end
end
