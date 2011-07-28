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

          def attribute_names
            @attribute_names ||= super | [:site_id, :section_id, :title, :body, :slug, :published_at, :filter, :categories]
          end

          def site
            section.try(:site)
          end

          def site_id
            site ? site.record.id.to_s : nil
          end

          def section
            @section ||= Section.new(source.strip_permalink)
          end

          def section_id
            section ? section.record.id.to_s : nil
          end

          def categories
            @categories ||= source.data.categories.map { |name| Category.find_or_initialize_by_name(name, :section_id => section.record.id) }
          end
        end
      end
    end
  end
end
