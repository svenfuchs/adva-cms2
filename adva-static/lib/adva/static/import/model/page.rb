module Adva
  class Static
    class Import
      module Model
        class Page < Section
          PATTERN = %r([\w-]+\.(#{Source::TYPES.join('|')})$)

          class << self
            def recognize(sources)
              return [] if sources.blank?

              pages = sources.select { |source| source.to_s =~ PATTERN }
              sources.replace(sources - pages)

              pages = pages.map { |source| source.self_and_parents.map(&:find_or_self) }.flatten.uniq
              pages = pages.map { |source| new(source) }
              pages
            end
          end

          def attribute_names
            @attribute_names ||= super + [:article_attributes]
          end

          def article_attributes
            attributes = { :title => name, :body => body }
            record.persisted? ? attributes.merge(:id => record.article.id.to_s) : attributes
          end
        end
      end
    end
  end
end
