When /^I drag the category "([^"]*)" behind the category "([^"]*)"$/ do |category, target|
  category = Category.find_by_name(category)
  target = Category.find_by_name(target)
  section = Section.first
  put(admin_site_section_path(section.site, section), {
    :section   => { :categories_attributes => [{ :id => category.id, :left_id => target.id }] },
    :return_to => @request.url
  })
  follow_redirect!
end

Then /^the ([\w]+) (name|title)d "([^"]+)" should be categorized as "([^"]+)"$/ do |model, attribute, value, category|
  record = model.classify.constantize.where(attribute => value).first
  assert record.categories.map(&:name).include?(category), "expected #{record.inspect} to be categorized as #{category}"
end

Then /^the ([\w]+) (name|title)d "([^"]+)" should not be categorized as "([^"]+)"$/ do |model, attribute, value, category|
  record = model.classify.constantize.where(attribute => value).first
  assert !record.categories.map(&:name).include?(category), "expected #{record.inspect} not to be categorized as #{category}"
end

