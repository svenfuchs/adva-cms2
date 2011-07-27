require 'simple_slugs'

module Adva
  class Static
    class Import
      module Source
        class Post < Base
          PERMALINK = %r((?:^|/)(\d{4})(?:\-|\/)(\d{1,2})(?:\-|\/)(\d{1,2})(?:\-|\/)(.*)$)

          class << self
            def recognize(paths)
              posts = paths.map { |path| path.self_and_descendants }.flatten.select { |path| permalink?(path) }
              posts = posts.map { |path| new(path) }
              paths.replace(paths - posts.map(&:permalink_paths).flatten)
              posts
            end

            def permalink?(path)
              path.to_s =~ PERMALINK
            end
          end

          def categories
            @categories ||= Array(read.categories).map { |category| category.split(',') }.flatten.map(&:strip)
          end

          def title
            @title ||= read.title || path_tokens.last.titleize
          end

          def slug
            @slug ||= read.slug || SimpleSlugs::Slug.new(title).to_s
          end

          def published_at
            @published_at ||= DateTime.civil(*permalink[0..-2].map(&:to_i))
          end

          def permalink
            @permalink ||= path_tokens.to_a[0..-2] << slug
          end

          def permalink_paths
            path.self_and_parents - path.root.self_and_parents
          end

          def strip_permalink
            path.gsub(Post::PERMALINK, '')
          end

          def data
            super.merge(:categories => categories, :title => title, :slug => slug, :published_at => published_at)
          end

          protected

            def path_tokens
              @path_tokens ||= path.to_s.gsub(/\.\w+$/, '').match(PERMALINK).to_a[1..-1]
            end
        end
      end
    end
  end
end



