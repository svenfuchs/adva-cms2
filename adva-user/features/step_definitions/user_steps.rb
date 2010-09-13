Given(/a confirmed user with email "([^"]+)" and password "([^"]+)"/) do |email, password|
  user = User.without_callbacks.create!(:email => email, :password => password)
  user.confirm!
end

Then 'I should be signed in' do
  When 'I go to the sign in page'
  Then 'I should be on the homepage'
end