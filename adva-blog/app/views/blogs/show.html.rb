class Blogs::Show < Minimal::Template
  def to_html
    unless resource.posts.empty?
      ul :class => 'posts' do
        resource.posts.each do |post|
          li :class => 'post hentry' do
            h2 do
              link_to(post.title, [resource, post], :class => 'entry-title', :rel => 'bookmark')
            end
            render :partial => 'posts/meta', :locals => { :post => post }
            div truncate_html(post.body, :length => 500, :omission => ' …'), :class => 'entry-content'
            p do
              link_to('Read the rest of this entry', [resource, post])
            end
          end
        end
      end
    end
  end
end



