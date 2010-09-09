class Admin::Sections::Menu < Adva::Views::Menu::Admin::Actions
  def main
    label(:'.sections')
  end
  
  def right
    item(:'.new', new_admin_site_section_path(site))
    item(:'.reorder', admin_site_sections_path(site), :activate => false)
  end
end