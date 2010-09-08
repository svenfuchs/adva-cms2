Given /^I am signed in with "([^"]*)" and "([^"]*)"$/ do |email, password|
  get new_user_session_path
  fill_in 'Email', :with => email
  fill_in 'Password', :with => password
  click_button 'Sign in'
end

# e.g. a blog titled "Blog"
Given /^an? (.*) (name|title)d "([^"]+)"$/ do |model, attribute, value|
  model = model.classify.constantize
  attributes = { attribute => value }
  attributes[:site_id]    = current_site.id    if model.column_names.include?('site_id')
  attributes[:account_id] = current_account.id if model.column_names.include?('account_id')
  model.find(:first, :conditions => attributes) || model.create!(attributes)
end

# e.g. a post with the title "Post" for the blog "Blog"
Given /^an? (.*) with the (\w+) "([^"]+)" for the (\w+) "([^"]+)"$/ do |model, attribute, value, section, title|
  section = Given(%(a #{section} titled "#{title}"))
  collection = section.send(model.underscore.pluralize)
  attributes = { attribute => value }
  collection.find(:first, :conditions => attributes) || collection.create!(attributes)
end

Then /^I should not see any (\w*)$/ do |type|
  assert_select(".#{type},.#{type.singularize}", :count => 0)
end

Then /^I should see an? (\w*)$/ do |type|
  assert_select(".#{type}")
end

Then /^I should see an? (\w*) (?:titled|named) "([^"]*)"$/ do |type, text|
  assert_select(".#{type} h2", text)
end

Then /^I should see an? (\w*) containing "([^"]*)"$/ do |type, text|
  assert_select(".#{type}", /#{text}/)
end

Then /^I should see an? ([a-z ]+) form$/ do |type|
  type = type.gsub(' ', '_') #.gsub(/edit_/, '')
  assert_select("form.#{type},form##{type}")
end