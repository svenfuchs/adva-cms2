module NavigationHelpers
  def path_to(page_name)
    case page_name
    when /the home\s?page/
      '/'
    when /the admin dashboard page for the site on "(.*)"/
      site = Site.find_by_host($1) || raise("could not find site with host #{$1}")
      admin_site_path(site)
    when /the admin posts list page of the "(.*)" blog/
      section = Blog.find_by_title($1) || raise("could not find blog #{$1.inspect}")
      admin_site_section_path(section.site, section)
    when /the admin products list page of the "(.*)" catalog/
      section = Catalog.find_by_title($1) || raise("could not find catalog #{$1.inspect}")
      admin_site_section_path(section.site, section)
    when 'the admin sites page'
      admin_sites_path
    when 'the admin dashboard page'
      admin_site_path(Site.first)
    when 'the admin site sections page'
      admin_site_sections_path(1)
    when 'the site installation page'
      new_installation_path
    when 'the home section page'
      section_path(Site.first.sections.first) # TODO
    when /the "(.*)" section page/
      section_path(Section.where(:title => $1).first)
    when 'the signin page'
      new_user_session_path
    else
      named_route_helper = page_name.gsub(/(\Athe )|( page\Z)/, '').gsub(/ +/, '_').downcase + '_path'
      raise "Can't find mapping from \"#{page_name}\" to a path.\nNow, go and add a mapping in #{__FILE__}" unless respond_to?(named_route_helper)
      send named_route_helper
    end
  end
end

World(NavigationHelpers)
