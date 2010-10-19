When /^I drag the category "([^"]*)" below the category "([^"]*)"$/ do |category, target|
  category = Category.find_by_name(category)
  target = Category.find_by_name(target)
  section = Section.first
  put(admin_site_section_path(section.site, section), {
    :section   => { :categories_attributes => [{ :id => category.id, :left_id => target.id }] },
    :return_to => @request.url
  })
  follow_redirect!
end

