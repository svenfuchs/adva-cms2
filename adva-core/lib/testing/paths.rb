module Adva::Core::Paths
  def path_to(page)
    case page

    when /^\//
      page

    when /^the home\s?page$/
      '/'

    when /^the site installation page$/
      new_installation_path

    when /^the site installation confirmation page$/
      installation_path(Site.last)

    when /^the "([^"]*)" section page$/
      section = Section.where(:name => $1).first || raise("could not find section named #{$1}")
      polymorphic_path(section)

    when /^the admin sites page$/
      polymorphic_path([:admin, :sites])

    when /^the admin dashboard page$/
      site = Site.first
      polymorphic_path([:admin, site])

    when /^the admin dashboard page for the site on "([^"]*)"$/
      site = Site.find_by_host($1) || raise("could not find site with host #{$1}")
      polymorphic_path([:admin, site])

    when /^the admin sections page$/
      site = Site.first
      polymorphic_path([:admin, site, :sections])

    when /^the admin "([^"]*)" section page$/
      site = Site.first
      section = Section.where(:name => $1).first || raise("could not find section named #{$1}")
      polymorphic_path([:admin, site, section])

    else
      named_route_helper = page.gsub(/(\Athe )|( page\Z)/, '').gsub(/ +/, '_').downcase + '_path'
      raise "Can't find mapping from \"#{page}\" to a path.\nNow, go and add a mapping in #{__FILE__}" unless respond_to?(named_route_helper)
      send named_route_helper
    end
  end
end

World(Adva::Core::Paths)
