Given /^I (?:am signed|sign) in with "([^"]*)" and "([^"]*)"$/ do |email, password|
  Given %Q~I am on the sign in page~
  # use ids to be flexible about label changes
   When %Q~I fill in "user_email" with "#{email}"~
    And %Q~I fill in "user_password" with "#{password}"~
    And %Q~I press "Sign in"~
  @user = User.find_by_email(email)
end

Given /a confirmed user with email "([^"]+)" and password "([^"]+)"/ do |email, password|
  Factory :user, :email => email, :password => password
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
  unless user.include?('the') || user.include?('"')
    Given %{#{user} exists}
  end
  user = model!(user)
  And %Q~I am signed in with "#{user.email}" and "#{Factory::DefaultPassword}"~
end

