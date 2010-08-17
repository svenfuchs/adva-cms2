module Adva
  module Importers
    class Directory
      module Loadable
        def initialize(*args)
          super
          load!
        end
        
        def loadable
          self
        end
        
        def load!
          send(:"load_#{File.extname(loadable).gsub('.', '')}!") if File.file?(loadable)
        end
        
        def load_yml!
          data = YAML.load_file(loadable)
          data.each { |key, value| instance_variable_set(:"@#{key}", value) } if data.is_a?(Hash)
        end
      end
    end
  end
end