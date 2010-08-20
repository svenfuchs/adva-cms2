module Adva
  module Importers
    class Directory
      class Blog < Section
        PERMALINK = %r((?:^|/)\d{4}/\d{1,2}/\d{1,2}/.*$)
        YEAR      = %r((?:^|/)(\d{4})(?:/|$))
        
        class << self
          def build(paths)
            return [] if paths.empty?
            root = paths.first.root
            posts = select_by_permalink(paths)
            years = extract_year(posts)
            paths.reject! { |path| years.include?(year(path)) }
            strip_permalink(posts).map { |blog| new(blog, root) }
          end
          
          def select_by_permalink(paths)
            paths.select { |path| permalink?(path) }
          end
          
          def permalink?(path)
            path.to_s =~ PERMALINK
          end
          
          def year(path)
            path.to_s =~ YEAR and $1
          end
          
          def extract_year(paths)
            paths.map { |post| post.to_s =~ YEAR and $1 }.uniq
          end
          
          def strip_permalink(paths)
            paths.map { |path| path.to_s.gsub!(PERMALINK, '') }.uniq
          end
        end
        
        def section
          @section ||= ::Blog.new(:title => title, :posts => posts.map(&:post).compact)
        end
        
        def posts
          @posts ||= Post.build(self)
        end
      end
    end
  end
end