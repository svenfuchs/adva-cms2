Then /^I should see flash message "([^"]*)"$/ do |message|
  Then %Q{I should see "#{message}" within ".flash"}
end

