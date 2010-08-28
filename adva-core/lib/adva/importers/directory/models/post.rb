module Adva
  module Importers
    class Directory
      module Models
        class Post < Base
          class << self
            def build(path)
              posts = Dir["#{path.to_s.gsub('.yml', '')}/*/*/*/*.yml"]
              posts.map { |post| new(Path.new(post, path.root)) }
            end
          end
          
          def initialize(path)
            super(path)
            load!
          end
          
          def attribute_names
            [:title, :body, :created_at] # TODO created_at should be published_at
          end

          def record
            @record ||= section.posts.by_permalink(*permalink).all.first || section.posts.build
          end
          
          def section
            @section ||= Blog.new(section_path).record
          end
          
          def section_path
            Blog.strip_permalink(source).first
          end

          def title
            @title ||= File.basename(source, source.extname).titleize
          end
          
          def permalink
            source.to_s.match(%r((\d{4})/(\d{1,2})/(\d{1,2}))).to_a[1..-1] << slug
          end

          def created_at
            @created_at ||= DateTime.civil(*permalink[0..-2].map(&:to_i))
          end
        end
      end
    end
  end
end