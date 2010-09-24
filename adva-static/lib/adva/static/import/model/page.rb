module Adva
  class Static
    module Import
      module Model
        class Page < Section
          PATTERN = %r([\w-]+\.(#{Source::TYPES.join('|')})$)
      
          class << self
            def recognize(paths)
              return [] if paths.blank?

              pages = paths.select { |path| path.to_s =~ PATTERN }
              paths.replace(paths - pages)

              pages = pages.map { |path| path.self_and_parents }.flatten.uniq
              pages = pages.map { |path| new(path) }
              pages
            end
          end

          # def initialize(path)
          #   path = File.dirname(path) if File.basename(path, File.extname(path)) == 'index'
          #   super
          # end

          def attribute_names
            [:site_id, :type, :name, :slug, :path, :article_attributes]
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