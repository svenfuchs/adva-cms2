module Adva
  class Static
    module Import
      class Directory
        module Models
          class Blog < Section
            PERMALINK = %r((?:^|/)\d{4}/\d{1,2}/\d{1,2}/(.*)$)

            class << self
              def build(paths)
                return [] if paths.blank?

                paths = Array(paths)
                posts = paths.select { |path| permalink?(path) }
                blogs = strip_permalink(posts).uniq
                paths.replace(paths - blogs - posts)
                blogs.map { |path| new(path) }
              end

              def permalink?(path)
                path.to_s =~ PERMALINK
              end

              def strip_permalink(paths)
                Array(paths).map { |path| Path.new(path.to_s.gsub!(PERMALINK) { $2 }, path.root) }
              end
            end

            def attribute_names
              [:type, :path, :name, :posts_attributes]
            end

            def model
              ::Blog
            end

            def posts_attributes
              Post.build(source).map(&:attributes)
            end
          end
        end
      end
    end
  end
end