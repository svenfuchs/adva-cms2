# Rails::Railtie::ABSTRACT_RAILTIES << 'Adva::Engine'

module Adva
  module Engine
    class << self
      def included(base)
        base.class_eval do
          include Initializations
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

    module Initializations
      def engine_name
        self.class.name.underscore.split('/').last
      end

      def load_rake_tasks
        begin
          load root.join("lib/tasks/#{engine_name}.rb")
        rescue LoadError
        end
      end

      def load_redirects
        begin
          load root.join('config/redirects.rb')
        rescue LoadError
        end
      end

      def preload_sliced_models
        types = %w(controllers models)
        paths = types.map { |type| self.paths.app.send(type).to_a.first }
        Dir["{#{paths.join(',')}}/**/*_slice.rb"].each { |path| require(path) }
      end

      def register_statics_middleware(app)
        if File.directory?(root.join('public'))
          app.middleware.use(ActionDispatch::Static, root.join('public').to_s)
        end
      end

      def copy_migrations
        Dir[root.join('db/migrate/*')].each do |source|
          target = File.expand_path(source.gsub(root.to_s, '.'))
          FileUtils.mkdir_p(File.dirname(target))
          FileUtils.cp(source, target)
        end
      end
    end
  end
end