module Adva
  module Importers
    class Directory
      class Post < Model
        class << self
          def build(path)
            glob(path).map { |path| new(path) }
          end
          
          def glob(path)
            Dir["#{path}/*/*/*/*.yml"].map { |p| Path.new(p, path) }
          end
        end
        
        def initialize(*args)
          @attribute_names = [:title, :body, :created_at] # TODO created_at should be published_at
          super
          load!
        end
        
        def post
          @post ||= ::Post.new(attributes)
        end
        
        def title
          @title ||= File.basename(self, extname).titleize
        end
        
        def created_at
          @created_at ||= DateTime.civil(*self.to_s.match(%r((\d{4})/(\d{1,2})/(\d{1,2}))).to_a[1..-1].map(&:to_i))
        end
      end
    end
  end
end