module Adva
  class Static
    class Import
      module Source
        class Blog < Section
          class << self
            def recognize(paths)
              posts = Post.recognize(paths)
              blogs = posts.map { |post| post.strip_permalink }.flatten.uniq
              blogs = blogs.map { |blog| paths.detect { |path| blog.to_s == path.to_s } || blog }

              paths.replace(paths - blogs)
              blogs.map { |path| new(path, posts) }
            end
          end

          attr_reader :posts

          def initialize(path, posts = [])
            @posts = posts
            super(path)
          end

          def categories
            @categories ||= posts.map { |post| post.categories }.flatten.uniq
          end

          def data
            super.merge(:posts => posts, :categories => categories)
          end
        end
      end
    end
  end
end


