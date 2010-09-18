class Blogs::Show < Minimal::Template
  include do
    def to_html
      ul :class => 'blog posts' do
        resource.posts.each do |post|
          li :class => 'post hentry' do
            h2 do
              link_to(post.title, [resource, post], :class => 'entry-title', :rel => 'bookmark')
            end
            render :partial => 'posts/meta', :locals => { :post => post }
            div truncate_html(post.body, :length => 500, :omission => ' …'), :class => 'entry-content'
            p do
              link_to(:'.continue', [resource, post], :class => :continue)
            end
          end
        end
      end
    end
  end
end


