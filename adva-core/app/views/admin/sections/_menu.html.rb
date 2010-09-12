class Admin::Sections::Menu < Adva::View::Menu::Admin::Actions
  def main
    item(:'.sections', index_path)
  end
  
  def right
    item(:'.new', new_path)
    item(:'.reorder', index_path, :activate => false)
  end
end