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
      admin_site_blog_path(section.site, section)
    when /the admin products list page of the "(.*)" catalog/
      section = Catalog.find_by_title($1) || raise("could not find catalog #{$1.inspect}")
      admin_site_catalog_path(section.site, section)
    when 'the admin sites page'
      admin_sites_path
    when 'the admin dashboard page'
      admin_site_path(Site.first)
    when 'the admin site sections page'
      admin_site_sections_path(1)
    when 'the site installation page'
      new_installation_path
    when 'the home section page'
      # TODO remove Site.first
      section = Site.first.sections.first
      # TODO patch url_for to accept an options hash to pass to polymorphic_path
      url_for(section).gsub('http://www.example.com', '')
    when 'the cart page'
      cart_path
    when 'the enter new shipping address page'
      new_cart_addresses_path
    when 'the select payment method page'
      edit_cart_payment_method_path
    when 'the order confirmation page'
      new_cart_confirmation_path
    when /the "(.*)" section page/
      section = Section.where(:title => $1).first
      url_for(section).gsub('http://www.example.com', '')
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
