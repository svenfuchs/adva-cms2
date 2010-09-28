module Adva
  module Testing
    module Engine
      def setup_load_paths
        paths.app.each { |path| $:.unshift(path) if File.directory?(path) }
        ActiveSupport::Dependencies.autoload_paths.unshift(*paths.app)
      end

      def migrate
        ActiveRecord::Migrator.up(root.join('db/migrate'))
      end

      def load_assertions
        load_all('lib/testing/assertions')
      end

      def load_factories
        load_all('lib/testing/factories')
      end

      def load_cucumber_support
        load_all('lib/testing/step_definitions')
        load_all('lib/testing/paths')
      end

      def load_helpers
        load_all('lib/testing/helpers')
      end

      def load_all(search)
        Pathname.glob(root.join("#{search}{.rb,/*.rb}")).each do |file|
          require(file) if file.exist?
        end
      end
    end
  end
end