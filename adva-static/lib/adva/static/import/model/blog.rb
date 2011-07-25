module Adva
  class Static
    class Import
      module Model
        class Blog < Section
          def update!
            super
            # categories.each { |category| category.update! }
            posts.each { |post| post.update! }
          end

          # def categories
          #   @categories ||= source.categories.map { |category| Category.new(category) }
          # end

          def posts
            @posts ||= source.posts.map { |post| Post.new(post, self) }
          end
        end
      end
    end
  end
end
