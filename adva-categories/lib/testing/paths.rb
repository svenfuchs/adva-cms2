module Adva::Categories::Paths
  def path_to(page)
    case page
    when /^the admin "([^"]*)" section categories page$/
      site = Site.first
      section = Section.where(:name => $1).first || raise("could not find section named #{$1}")
      polymorphic_path([:admin, site, section, :categories])
    else
      super
    end
  end
end

World(Adva::Categories::Paths)

