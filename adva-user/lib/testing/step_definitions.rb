Given /^I (?:am signed|sign) in with "([^"]*)" and "([^"]*)"$/ do |email, password|
  Given %Q~I am on the sign in page~
  # use ids to be flexible about label changes
   When %Q~I fill in "user_email" with "#{email}"~
    And %Q~I fill in "user_password" with "#{password}"~
    And %Q~I press "Sign in"~
  @user = User.find_by_email(email)
end

Given /a confirmed user with email "([^"]+)" and password "([^"]+)"/ do |email, password|
  user = User.without_callbacks.create!(:email => email, :password => password)
  user.confirm!
end

Then 'I should be signed in' do
  When 'I go to the sign in page'
  Then 'I should be on the homepage'
end
