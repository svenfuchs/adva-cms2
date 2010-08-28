module Adva
  module Importers
    class Directory
      class Import
        attr_reader :root, :path, :routes

        def initialize(root, path, options = {})
          @root = Path.new(File.expand_path(root))
          @path = absolutize_path(path)
          @routes = options[:routes] || Rails.application.routes
        end

        def record
          model.updated_record
        end

        def params
          @params ||= routes.recognize_path(path.path, env)
        rescue ActionController::RoutingError => e
          puts "can't recognize #{path} because: #{e.message}"
          nil
        end
        
        def request
          Request.new(self)
        end
        
        def model
          @model ||= Models.const_get(model_name.camelize).new(path)
        end

        def model_name
          params[:controller].split('/').last.gsub('_controller', '').singularize
        end

        def absolutize_path(path)
          path = path.to_s.gsub(/^(#{root.to_s})?\/?/, '')
          path = root.join(path)
          Path.new(path, root)
        end
        
        def site
          @site ||= ::Site.first || raise("could not find any site") # FIXME
        end

        def env
          { 'SERVER_NAME' => site.host }
        end
      end
    end
  end
end