require 'core_ext/ruby/array/flatten_once'

module Adva
  module Importers
    class Directory
      class Model < Path
        include Loadable

        attr_reader :attribute_names
        
        def initialize(*args)
          raise 'got to set @attribute_names' if @attribute_names.nil?
          super
        end
        
        def attributes
          Hash[*attribute_names.map { |name| [name, self.send(name)] }.flatten_once]
        end

        def slug
          File.basename(self)
        end
        
        def body
          @body || ''
        end
        
        def updated_at
          self.mtime
        end
      end
    end
  end
end