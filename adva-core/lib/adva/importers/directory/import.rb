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

        def sync!
          record.save!
        end

        def record
          importer.record(params)
        end

        def params
          @params ||= routes.recognize_path(path.path, env)
        rescue ActionController::RoutingError => e
          puts "can't recognize #{path} because: #{e.message}"
        end
        
        def changes
          @changes ||= record.changed.inject(HashWithIndifferentAccess.new) do |changes, name| 
            changes[name] = record.send(name)
            changes
          end
        end
        
        def importer
          Models.const_get(model_name.camelize).new(path)
        end
        
        def request
          Request.new(self)
        end

        def model_name
          params[:controller].split('/').last.gsub('_controller', '').singularize
        end

        def absolutize_path(path)
          Path.new(root.join(path.to_s.gsub(/^#{root.to_s}\//, '')), root) # TODO ???
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