require 'core_ext/ruby/array/flatten_once'

module Adva
  class Static
    class Import
      module Model
        class Base
          attr_reader :source, :attribute_names

          def initialize(source)
            @source = source.is_a?(Source::Base) ? source : Source.build(model_name, source)
          end

          def update!
            updated_record.save!
          end

          def updated_record
            record.tap { |record| record.attributes = attributes }
          end

          def attributes
            attributes = attribute_names.map { |name| [name, attribute_value(name)] if attribute_value(name) } # attribute?(name)
            attributes = Hashr.new(Hash[*attributes.compact.flatten_once])
            record && record.id ? attributes.merge(:id => record.id.to_s) : attributes
          end

          def attribute_value(name)
            respond_to?(name) ? self.send(name) : source.data.send(name)
          end

          def attribute?(name)
            source.data.key?(name) || respond_to?(name)
          end

          def model
            model_name.constantize
          end

          def model_name
            @model_name ||= self.class.name.demodulize
          end

          # def updated_at
          #   source.mtime
          # end
        end
      end
    end
  end
end
