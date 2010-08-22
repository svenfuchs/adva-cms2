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
            posts = paths.select { |path| permalink?(path) }
            years = extract_year(posts)
            paths.reject! { |path| years.include?(year(path)) }
            strip_permalink(posts).map { |blog| new(blog, root) }
          end
          
          def permalink?(path)
            path.to_s =~ PERMALINK
          end
          
          def extract_year(paths)
            paths.map { |path| year(path) }.uniq
          end
          
          def year(path)
            path.to_s =~ YEAR and $1
          end
          
          def strip_permalink(paths)
            paths.map { |path| path.to_s.gsub!(PERMALINK, '') }.uniq
          end
        end
        
        def initialize(*args)
          @attribute_names = [:path, :title, :posts]
          super
        end
        
        def section
          @section ||= ::Blog.new(attributes)
        end
        
        def posts
          @posts ||= Post.build(self).map(&:post).compact
        end
      end
    end
  end
end