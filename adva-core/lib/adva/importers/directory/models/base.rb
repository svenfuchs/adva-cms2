require 'core_ext/ruby/array/flatten_once'

module Adva
  module Importers
    class Directory
      module Models
        class Base < Path
          autoload :Base,    'adva/importers/directory/models/base'
          autoload :Blog,    'adva/importers/directory/models/blog'
          autoload :Post,    'adva/importers/directory/models/post'
          autoload :Section, 'adva/importers/directory/models/section'
          autoload :Site,    'adva/importers/directory/models/site'
        
          attr_reader :model, :attribute_names

          def initialize(*args)
            raise 'got to set @attribute_names' if @attribute_names.nil?
            super
            load!
          end

          def sync!(params)
            record(params).save!
          end

          def record(params)
            @id = params[:id] # TODO uuuugh.
            @record ||= find_or_instantiate(params[:id]).tap { |record| record.attributes = attributes }
          end
        
          def find_or_instantiate(id)
            model.find(id) rescue model.new
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
end