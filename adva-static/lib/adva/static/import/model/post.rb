module Adva
  class Static
    class Import
      module Model
        class Post < Base
          delegate :permalink, :published_at, :to => :source

          attr_reader :section

          def initialize(source, section = nil)
            super(source)
            @section = section
          end

          def record
            @record ||= ::Post.by_permalink(*permalink).first || ::Post.new
          end

          def attributes
            super
          end

          def attribute_names
            @attribute_names ||= [:section_id, :title, :body, :slug, :published_at, :filter] # , :categorizations_attributes
          end

          def section_id
            section ? section.record.id.to_s : nil
          end

          # def categorizations_attributes
          #   categories.map do |name|
          #     { :category => section.categories.find_or_initialize_by_name(name, :section => section) } # OMG yes!
          #   end if categories
          # end
        end
      end
    end
  end
end
