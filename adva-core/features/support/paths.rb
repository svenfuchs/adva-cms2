module Adva::Core::Paths
  def path_to(page_name)
    case page_name
    when 'the site installation page'
      new_installation_path
    when /the home\s?page/
      '/'
    when 'the home section page'
      '/'
    when /the "([^"]*)" section page/
      section = Section.where(:title => $1).first
      polymorphic_path(section)
    when 'the sign in page'
      new_user_session_path
    when 'the new registration page'
      new_user_registration_path
    when 'the admin sites page'
      polymorphic_path([:admin, :sites])
    when 'the admin dashboard page'
      polymorphic_path([:admin, Site.first])
    when /the admin dashboard page for the site on "([^"]*)"/
      site = Site.find_by_host($1) || raise("could not find site with host #{$1}")
      polymorphic_path([:admin, site])
    when 'the admin site sections page'
      polymorphic_path([:admin, Site.first, :sections])
    when /the admin "([^"]*)" section page/
      section = Section.where(:title => $1).first || raise("could not find section named #{$1}")
      polymorphic_path([:admin, Site.first, section])
    when /the admin posts list page of the "([^"]*)" blog/
      section = Blog.find_by_title($1) || raise("could not find blog #{$1.inspect}")
      polymorphic_path([:admin, section.site, section])
    when /the admin edit post page for the post "([^"]*)"/
      post = Post.find_by_title($1) || raise("could not find post #{$1.inspect}")
      polymorphic_path([:edit, :admin, post.section.site, post.section, post])
    else
      named_route_helper = page_name.gsub(/(\Athe )|( page\Z)/, '').gsub(/ +/, '_').downcase + '_path'
      raise "Can't find mapping from \"#{page_name}\" to a path.\nNow, go and add a mapping in #{__FILE__}" unless respond_to?(named_route_helper)
      send named_route_helper
    end
  end
end

World(Adva::Core::Paths)
