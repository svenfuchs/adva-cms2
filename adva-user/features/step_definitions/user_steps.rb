Given(/a confirmed user with email "([^"]+)" and password "([^"]+)"/) do |email, password|
  user = User.without_callbacks.create!(:email => email, :password => password)
  user.confirm!
end