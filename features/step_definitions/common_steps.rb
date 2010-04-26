Then /^I should see an? (\S+) (\S+) form$/ do |action, resource|
  assert_select("form.#{action}_#{resource}")
end