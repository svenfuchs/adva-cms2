atom_feed({ :id => "tag:#{site.host},2011:atom" }) do |feed|
  feed.title(site.title)
  feed.updated(collection.first.published_at)
  collection[0, 15].each do |post|
    feed.entry([blog, post], :id => "tag:#{site.host},2011:#{post.slug}") do |entry|
      entry.title(post.title)
      entry.content(post.body_html, :type => 'html')
      entry.updated(post.published_at.xmlschema)
      entry.author do |author|
        author.name('') # post.author_name
      end
    end
  end
end
