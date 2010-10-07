Given /^I am signed in with "([^"]*)" and "([^"]*)"$/ do |email, password|
  get new_user_session_path
  fill_in 'Email', :with => email
  fill_in 'Password', :with => password
  click_button 'Sign in'
end

Given /a confirmed user with email "([^"]+)" and password "([^"]+)"/ do |email, password|
  user = User.without_callbacks.create!(:email => email, :password => password)
  user.confirm!
end

Then 'I should be signed in' do
  When 'I go to the sign in page'
  Then 'I should be on the homepage'
end
