Then /^I should see an article titled "([^"]*)"$/ do |title|
  assert_select('h2', title)
end

Then /^I should see an articles list$/ do
  assert_select('ul.articles')
end

Then /^I should not see an articles list$/ do
  assert_select('ul.articles', :count => 0)
end