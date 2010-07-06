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

Given(/I am signed in/) do
  @user = User.find_or_create_by_email(:email => 'bob@domain.com', :password => 'bobpass')
  get new_user_session_path
  fill_in 'Email', :with => @user.email
  fill_in 'Password', :with => 'bobpass'
  click_button 'Sign in'
end