module Adva
  class Static
    class Import
      module Format
        def self.for(path)
          name = File.extname(path).gsub('.', '').camelize
          const_get(name).new(path) if name.present?
        end

        class Base
          attr_reader :path

          def initialize(path)
            @path = path
          end

          def load(target)
            data.each do |name, value|
              define_attribute(target, name) if define_attribute?(target, name)
              target.instance_variable_set(:"@#{name}", value)
            end if data.is_a?(Hash)
          end

          def define_attribute?(target, name)
            !target.attribute_name?(name) && target.column_name?(name)
          end

          def define_attribute(target, name)
            target.attribute_names << name
            target.attribute_names.uniq!
            target.class.send(:attr_reader, name) unless target.respond_to?(name)
          end
        end

        class Yml < Base
          def data
            @data ||= YAML.load_file(path)
          end
        end

        class Jekyll < Base
          def data
            @data ||= begin
              file =~ /^(---\s*\n.*?\n?)^---\s*$\n?(.*)/m
              data = YAML.load($1) rescue {}
              data.merge!(:body => $2) if $2
              data
            end
          end

          def file
            @file ||= File.read(path)
          end
        end
      end
    end
  end
end
