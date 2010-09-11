class Admin::Sections::Menu < Adva::Views::Menu::Admin::Actions
  def main
    item(:'.sections', admin_site_sections_path(site))
  end
  
  def right
    item(:'.new', new_admin_site_section_path(site))
    item(:'.reorder', admin_site_sections_path(site), :activate => false)
  end
end