class Admin::Blogs::Show < Minimal::Template
  def to_html
    h2 resource.title

    unless resource.posts.empty?
      ul :class => 'posts' do
        resource.posts.each do |post|
          li link_to post.title, resources.unshift(:edit).push(post)
        end
      end
    end
  end
end