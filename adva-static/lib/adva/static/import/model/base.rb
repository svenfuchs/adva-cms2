require 'core_ext/ruby/array/flatten_once'

module Adva
  class Static
    module Import
      module Model
        class Base
          attr_reader :source, :attribute_names

          def initialize(source)
            @source = source
            # load
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

          def model
            self.class.name.demodulize.constantize
          end

          def site_id
            site.id.to_s
          end

          def slug
            source.basename
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

          def load
            Format.for(loadable).load(self) if File.file?(loadable.to_s)
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