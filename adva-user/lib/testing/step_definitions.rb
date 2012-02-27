Given /^I (?:am signed|sign) in with "([^"]*)" and "([^"]*)"$/ do |email, password|
  Given %(I am on the sign in page)
  # use ids to be flexible about label changes
   When %(I fill in "user_email" with "#{email}")
    And %(I fill in "user_password" with "#{password}")
    And %(I press "Sign in")
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

# Two ways to use:
#  Given I am logged in as admin
#    => created the admin and login
#  Given a user "Peter" exists with email: "peter-lustig@example.com"
#    And I am logged in as the user "Peter"
#    => uses the prepared user to log in
#
# Please set the passwort if the user only for auth tests
Given /^I (?:am signed|sign) in as #{capture_model}$/ do |user|
  Given %(#{user} exists) unless user.include?('the') || user.include?('"')
  user = model!(user)
  And %(I am signed in with "#{user.email}" and "#{Factory::DefaultPassword}")
end

