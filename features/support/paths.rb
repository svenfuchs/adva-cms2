module NavigationHelpers
  def path_to(page_name)
    case page_name
    when /the home\s?page/
      '/'
    when 'the admin dashboard page'
      # admin_site_path
      '/admin/sites/1'
    when 'the admin site sections page'
      admin_site_sections_path(1)
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
