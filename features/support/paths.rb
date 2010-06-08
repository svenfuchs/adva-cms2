module NavigationHelpers
  def path_to(page_name)
    case page_name
    when /the home\s?page/
      '/'
    when /the admin dashboard page for the site on "(.*)"/
      site = Site.find_by_host($1) || raise("could not find site with host #{$1}")
      admin_site_path(site)
    when 'the admin dashboard page'
      admin_site_path(Site.first)
    when 'the admin site sections page'
      admin_site_sections_path(1)
    when 'the site installation page'
      new_installation_path
    when 'the home section page'
      section_path(Site.first.sections.first) # TODO
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
