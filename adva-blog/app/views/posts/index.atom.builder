atom_feed({ :id => "tag:#{site.host}" }) do |feed|
  feed.title(site.title)
  feed.updated((@posts.first.created_at))

  for post in @posts
    feed.entry([blog, post], :id => "tag:#{site.host}:#{post.id}") do |entry|
      entry.title(post.title)
      entry.content(post.body_html, :type => 'html')
      # entry.author do |author|
      #   author.name(post.author_name)
      # end
    end
  end
end

