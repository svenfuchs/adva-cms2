Then /^I should see a (\S+) (\S+) form$/ do |action, resource|
  assert_select("form.#{action}_#{resource}")
end