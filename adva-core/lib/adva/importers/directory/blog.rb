module Adva
  module Importers
    class Directory
      class Blog < Section
        PATTERN = %r(\d{4}/\d{1,2}/\d{1,2}/.*$)
        
        class << self
          def detect(paths)
            posts = paths.select { |path| path.to_s =~ PATTERN }
            # TODO this leaves archive directories in the path array
            paths.replace(paths - posts)
            posts.map { |path| new(path.to_s.gsub!(PATTERN, '')) }.uniq
          end
        end
        
        def section
          @section ||= ::Blog.new(:title => title, :posts => posts.map(&:post).compact)
        end
        
        def posts
          @posts ||= Post.detect(self)
        end
        
        def title
          @title ||= root? ? 'Home' : local_path.to_s.titleize
        end
      end
    end
  end
end