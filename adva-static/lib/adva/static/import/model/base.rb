require 'core_ext/ruby/array/flatten_once'

module Adva
  class Static
    class Import
      module Model
        class Base
          attr_reader :source, :attribute_names

          def initialize(source)
            @source = source
            load
          end

          def attributes
            attributes = attribute_names.map { |name| [name, self.send(name)] unless self.send(name).nil? }
            attributes = Hash[*attributes.compact.flatten_once]
            record && record.id ? attributes.merge(:id => record.id.to_s) : attributes
          end

          def attribute_name?(name)
            attribute_names.include?(name.to_sym)
          end

          def column_name?(name)
            model.column_names.include?(name.to_s)
          end

          def updated_record
            record.tap { |record| record.attributes = attributes }
          end

          def model
            self.class.name.demodulize.constantize
          end

          def site_id
            site.id.to_s
          end

          def slug
            source.basename
          end

          def path
            source.path
          end

          def body
            @body || ''
          end

          def updated_at
            source.mtime
          end

          def loadable
            @loadable ||= source.full_path
          end

          def load
            if loadable.exist?
              format = Format.for(loadable) and format.load(self)
            end
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
