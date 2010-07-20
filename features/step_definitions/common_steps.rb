Given /^I am signed in$/ do
  # TODO extract to memoizing attribute_reader
  @current_user = User.find_or_create_by_email(:email => 'bob@domain.com', :password => 'bobpass')
  get new_user_session_path
  fill_in 'Email', :with => @current_user.email
  fill_in 'Password', :with => 'bobpass'
  click_button 'Sign in'
end

Given /^an? (.*) (name|title)d "([^"]+)"$/ do |model, attribute, value|
  model = model.classify.constantize
  attributes = { attribute => value }
  attributes[:site]    = @current_site    if model.column_names.include?('site_id')
  attributes[:account] = @current_account if model.column_names.include?('account_id')
  model.create!(attributes)
end

Given /^the following (products):$/ do |model, table|
  model = model.classify.constantize
  table.hashes.each do |attributes|
    attributes[:site]    = @current_site    if model.column_names.include?('site_id')
    attributes[:account] = @current_account if model.column_names.include?('account_id')
    model.create!(attributes)
  end
end

Then /^I should not see any (\w*)$/ do |type|
  assert_select(".#{type},.#{type.singularize}", :count => 0)
end

Then /^I should see an? (\w*) (?:titled|named) "([^"]*)"$/ do |type, text|
  assert_select(".#{type} h2", text)
end

Then /^I should see an? (\w*) containing "([^"]*)"$/ do |type, text|
  assert_select(".#{type}", /#{text}/)
end

Then /^I should see an? ([a-z ]+) form$/ do |form|
  class_names = form.split
  if class_names.length == 2
    action, resource = class_names
    assert_select("form.#{action}_#{resource}")
  else
    assert_select("form.#{class_names.join('.')}")
  end
end