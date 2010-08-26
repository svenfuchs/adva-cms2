module Adva
  module Importers
    class Directory
      module Models
        class Post < Base
          class << self
            def build(path)
              glob(path).map { |path| new(path) }
            end

            def glob(path)
              Dir["#{path}/*/*/*/*.yml"].map { |p| Path.new(p, path) }
            end
          end

          def initialize(*args)
            @model = ::Post
            @attribute_names = [:title, :body, :created_at] # TODO created_at should be published_at
            super
            load!
          end

          def record(params)
            args = *params.values_at(:year, :month, :day, :slug)
            post = ::Blog.find(params[:blog_id]).posts.by_permalink(*args).all.first
            super(params.merge(:id => post.id))
          end

          def post
            @post ||= model.new(attributes)
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
end