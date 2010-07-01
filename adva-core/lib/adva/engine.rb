# Rails::Railtie::ABSTRACT_RAILTIES << 'Adva::Engine'

module Adva
  module Engine
    class << self
      def included(base)
        base.class_eval do
          name = base.name.underscore.split('/').last

          rake_tasks do
            begin
              load root.join("lib/tasks/#{name}.rb")
            rescue LoadError
            end
          end

          initializer "adva-#{name}.load_redirects" do |app|
            begin
              load root.join('config/redirects.rb')
            rescue LoadError
            end
          end

          initializer "adva-#{name}.register_middlewares" do |app|
            urls = %W(/images/adva_#{name} /javascripts/adva_#{name} /stylesheets/adva_#{name})
            urls = urls.select { |path| File.directory?(root.join("public/#{path}")) }
            app.middleware.use Rack::Static, :urls => urls, :root => root.join('public') unless urls.empty?
          end

          def self.copy_migrations
            Dir[root.join('db/migrate/*')].each do |source|
              target = File.expand_path(source.gsub(root.to_s, '.'))
              FileUtils.mkdir_p(File.dirname(target))
              FileUtils.cp(source, target)
            end
          end
        end
      end
    end
  end
end