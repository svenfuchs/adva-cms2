Then /^I should see an? (\w*)$/ do |type|
  assert_select(".#{type}")
end
