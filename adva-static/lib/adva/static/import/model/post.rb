module Adva
  class Static
    class Import
      module Model
        class Post < Base
          PERMALINK = %r((?:^|/)(\d{4})(?:\-|\/)(\d{1,2})(?:\-|\/)(\d{1,2})(?:\-|\/)(.*)$)

          class << self
            def recognize(sources)
              posts = sources.select { |source| source.path =~ PERMALINK }
              sources.replace(sources - posts.map(&:self_and_parents).flatten)
              posts.map { |post| new(post) }
            end

            def permalink?(path)
              path.to_s =~ PERMALINK
            end

            def strip_permalink(source)
              Source.new(source.to_s.gsub(Post::PERMALINK, ''), source.root)
            end
          end

          def attribute_names
            @attribute_names ||= [:site_id, :section_id, :title, :body, :created_at] # TODO [stuff] created_at should be published_at
          end

          def record
            @record ||= section.posts.by_permalink(*permalink).all.first || section.posts.build
          end

          def site_id
            section.site_id.to_s
          end

          def section
            @section ||= Blog.new(section_source).record
          end

          def section_id
            section.id.to_s
          end

          def section_source
            @section_source ||= begin
              source = self.class.strip_permalink(self.source)
              if source.path.present?
                source.find_or_self
              else
                Source.new(source.join('index'), source.root).find_or_self
              end
            end
          end

          def slug
            @slug ||= SimpleSlugs::Slug.new(title).to_s
          end

          def title
            @title ||= path_tokens.last.titleize
          end

          def permalink
            @permalink ||= path_tokens.to_a[0..-2] << slug
          end

          def path_tokens
            @path_tokens ||= source.to_s.gsub(/\.\w+$/, '').match(PERMALINK).to_a[1..-1]
          end

          def created_at
            @created_at ||= DateTime.civil(*permalink[0..-2].map(&:to_i))
          end
        end
      end
    end
  end
end
