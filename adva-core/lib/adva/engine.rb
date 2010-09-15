# Common behaviour that we want included in all adva engines

module Adva
  module Engine
    autoload :SlicedModels, 'adva/engine/sliced_models'

    class << self
      def included(base)
        base.class_eval do
          include Initializations # ugh. why does these need to be both class
          extend Initializations  # and instance methods?

          engine_name = base.name.underscore.split('/').last

          config.autoload_paths << paths.app.views.to_a.first

          paths.lib.tasks = Dir[root.join('lib/adva/tasks/*.*')]

          initializer "adva-#{engine_name}.require_patches" do |app|
            require_patches
          end

          initializer "adva-#{engine_name}.load_redirects" do |app|
            load_redirects
          end

          initializer "adva-#{engine_name}.register_statics_middleware" do |app|
            register_statics_middleware(app)
          end

          initializer "adva-#{engine_name}.preload_sliced_models" do |app|
            engine = self
            config.to_prepare { engine.preload_sliced_models }
          end
        end
      end
    end

    module Initializations
      include SlicedModels

      def engine_name
        name = is_a?(Class) ? self.name : self.class.name # ughugh.
        name.underscore.split('/').last
      end

      def require_patches
        Dir[root.join('lib/patches/**/*.rb')].each { |patch| require patch }
      end

      def load_redirects
        begin
          load root.join('config/redirects.rb')
        rescue LoadError
        end
      end

      def register_statics_middleware(app)
        if File.directory?(root.join('public'))
          app.middleware.use(ActionDispatch::Static, root.join('public').to_s)
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