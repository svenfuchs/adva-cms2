require 'core_ext/ruby/array/flatten_once'

module Adva
  class Static
    module Import
      class Directory
        module Models
          class Base
            autoload :Base,    'adva/static/import/directory/models/base'
            autoload :Blog,    'adva/static/import/directory/models/blog'
            autoload :Post,    'adva/static/import/directory/models/post'
            autoload :Section, 'adva/static/import/directory/models/section'
            autoload :Site,    'adva/static/import/directory/models/site'

            attr_reader :source, :attribute_names

            def initialize(source)
              @source = Path.new(source)
              load!
            end

            def sync!(params)
              record(params).save!
            end

            def attributes
              attributes = attribute_names.map { |name| [name, self.send(name)] unless self.send(name).nil? }
              attributes = Hash[*attributes.compact.flatten_once]
              record && record.id ? attributes.merge(:id => record.id.to_s) : attributes
            end

            def updated_record
              record.attributes = attributes
              record
            end

            def site_id
              site.id.to_s
            end

            def slug
              File.basename(source, '.yml')
            end

            def body
              @body || ''
            end

            def updated_at
              source.mtime
            end

            def loadable
              source
            end

            def load!
              send(:"load_#{File.extname(loadable).gsub('.', '')}!") if File.file?(loadable)
            end

            def load_yml!
              data = YAML.load_file(loadable)
              data.each { |key, value| instance_variable_set(:"@#{key}", value) } if data.is_a?(Hash)
            end

            def ==(other)
              source == other
            end

            def <=>(other)
              source <=> other.source
            end
          end
        end
      end
    end
  end
end