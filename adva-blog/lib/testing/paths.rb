module Adva::Blog::Paths
  def path_to(page)
    case page

    when /^the admin posts list page of the "([^"]*)" blog$/
      section = Blog.find_by_name($1) || raise("could not find blog #{$1.inspect}")
      polymorphic_path([:admin, section.site, section])

    when /^the admin edit post page for the post "([^"]*)"$/
      post = Post.find_by_title($1) || raise("could not find post #{$1.inspect}")
      polymorphic_path([:edit, :admin, post.section.site, post.section, post])

    else
      super
    end
  end
end

World(Adva::Blog::Paths)
