module Adva
  class Static
    module Import
      class Directory
        module Models
          class Post < Base
            PERMALINK = %r((?:^|/)(\d{4})(?:\-|\/)(\d{1,2})(?:\-|\/)(\d{1,2})(?:\-|\/)(.*)$)

            class << self
              def build(path)
                posts = self.posts(path)
                posts << path if path.to_s =~ PERMALINK
                posts.map { |post| new(Path.new(post, path.root)) }
              end
              
              def posts(path)
                path    = path.to_s.sub(%r(\.(#{Path::TYPES.join('|')})$), '')
                types   = Path::TYPES.join(',')
                pattern = "#{path}/**/*.{#{types}}"
                Dir[pattern].select { |path| path =~ PERMALINK }
              end
            end

            def initialize(path)
              super(path)
              load
            end

            def attribute_names
              [:site_id, :section_id, :title, :body, :created_at] # TODO created_at should be published_at
            end

            def record
              @record ||= section.posts.by_permalink(*permalink).all.first || section.posts.build
            end

            def section
              @section ||= Blog.new(section_path).record
            end

            def site_id
              section.site_id.to_s
            end
          
            def section_id
              section.id.to_s
            end

            def section_path
              Blog.strip_permalink(source).first
            end

            def slug
              @slug ||= SimpleSlugs::Slug.new(title).to_s # (super =~ PERMALINK and $4)
            end

            def title
              @title ||= File.basename(source, source.extname).titleize
            end

            def permalink
              source.to_s.match(PERMALINK).to_a[1..-2] << slug
            end

            def created_at
              @created_at ||= DateTime.civil(*permalink[0..-2].map(&:to_i))
            end
          end
        end
      end
    end
  end
end