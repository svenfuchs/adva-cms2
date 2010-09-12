Given /^I am signed in with "([^"]*)" and "([^"]*)"$/ do |email, password|
  get new_user_session_path
  fill_in 'Email', :with => email
  fill_in 'Password', :with => password
  click_button 'Sign in'
end

# e.g. a blog titled "Blog"
Given /^an? (.*) (name|title)d "([^"]+)"$/ do |model, attribute, value|
  model = model.classify.constantize
  attributes = { attribute => value }
  attributes[:site_id]    = site.id    if model.column_names.include?('site_id')
  attributes[:account_id] = account.id if model.column_names.include?('account_id')
  model.find(:first, :conditions => attributes) || model.create!(attributes)
end

# e.g. a post with the title "Post" for the blog "Blog"
Given /^an? (.*) with the (\w+) "([^"]+)" for the (\w+) "([^"]+)"$/ do |model, attribute, value, section, title|
  section = Given(%(a #{section} titled "#{title}"))
  collection = section.send(model.underscore.pluralize)
  attributes = { attribute => value }
  collection.find(:first, :conditions => attributes) || collection.create!(attributes)
end

Given(/^no site or account$/) do
  [Account, User, Site, Section].map(&:delete_all)
end

Then /^I should not see any (\w*)$/ do |type|
  assert_select(".#{type},.#{type.singularize}", :count => 0)
end

Then /^I should see an? (\w*)$/ do |type|
  assert_select(".#{type}")
end

Then /^I should see an? (\w*) (?:titled|named) "([^"]*)"$/ do |type, text|
  assert_select(".#{type} h2", text)
end

Then /^I should see an? (\w*) containing "([^"]*)"$/ do |type, text|
  assert_select(".#{type}", /#{text}/)
end

Then /^I should see an? ([a-z ]+) form$/ do |type|
  type = type.gsub(' ', '_') #.gsub(/edit_/, '')
  assert_select("form.#{type}, form##{type}")
end


Then /^I should see a table "(.*)" with the following entries:$/ do |table_id, expected_table|
  html_table = table(tableish("table##{table_id} tr", 'td,th'))
  begin
  expected_table.diff!(html_table)
  rescue
    puts expected_table
    raise
  end
end

Then(/^I should see the "([^"]+)" page$/) do |title|
  assert_select('h2', title)
end

Then(/(?:\$|eval) (.*)$/) do |code|
  pp eval(code)
end

Then /^I should see a flash (error|notice) "(.*)"$/ do |message_type, message|
  assert_match message, flash_cookie[message_type].to_s
end

Then /^I should not see a flash (error|notice) "(.*)"$/ do |message_type, message|
  assert_no_match /message/, flash_cookie[message_type].to_s
end

Then /^I (press|click) "(.*)" in the row where "(.*)" is "(.*)"$/ do |method, link_or_button, header, cell_content|
  body = Nokogiri::HTML(response.body)
  header_id = body.xpath("//th[normalize-space(text())='#{header}']/@id").first.value
  row_id = body.xpath("//tr/td[@headers='#{header_id}'][normalize-space(text())='#{cell_content}']/ancestor::tr/@id").first.value
  within("##{row_id}") do
    send({'press' => 'click_button', 'click' => 'click_link'}[method], link_or_button)
  end
end
