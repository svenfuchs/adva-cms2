module Adva
  module Engine
    class << self
      def included(base)
        base.class_eval do
          include Initializations # ugh. why does these need to be both class
          extend Initializations  # and instance methods?

          engine_name = base.name.underscore.split('/').last

          rake_tasks do
            load_rake_tasks
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

    module SlicedModels

      # TODO preloading seems to work fine, but slows the dev mode down quite
      # a bit. should be replace with an approace which lazyloads sliced
      # models in Dependencies maybe an after-load hook in Dependencies would
      # work.
      def preload_sliced_models
        types = %w(controllers models)
        paths = types.map { |type| self.paths.app.send(type).to_a.first }

        Dir["{#{paths.join(',')}}/**/*_slice.rb"].each do |filename|
          const_name = filename =~ %r(/([^/]*)_slice.rb) && $1.camelize
          # ActiveSupport::Dependencies.mark_for_unload(const_name)
          # ActiveSupport::Dependencies.autoloaded_constants << const_name
          # ActiveSupport::Dependencies.autoloaded_constants.uniq!
          # require_dependency(const_name.underscore)
          load(filename)
        end
      end
    end

    module Initializations
      include SlicedModels

      def engine_name
        name = is_a?(Class) ? self.name : self.class.name # ughugh.
        name.underscore.split('/').last
      end

      def load_rake_tasks
        begin
          load root.join("lib/tasks/#{engine_name}.rb")
        rescue LoadError => e
        end
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

# TODO move this ... where?
require 'rails'

Rails::Application.class_eval do
  include Adva::Engine::SlicedModels

  initializer "application.preload_sliced_models" do |app|
    config.to_prepare { app.preload_sliced_models }
  end
end