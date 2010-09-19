Given 'a site' do
  Factory(:site)
  Factory(:admin)
end

Given /^the following (\w*):$/ do |type, table|
  type = type.singularize
  table.hashes.each do |attributes|
    type = attributes.delete('type').underscore if attributes.key?('type')
    attributes['site']    = site if type.classify.constantize.column_names.include?('site_id')
    attributes['section'] = site.sections.find_by_name(attributes['section']) if attributes.key?('section')
    Factory(type, attributes)
  end
end

Given /^a site with the following sections:$/ do |table|
  Site.delete_all
  Given 'a site'
  Section.delete_all
  Given "the following sections:", table
end

# e.g. a blog named "Blog"
Given /^an? (.*) (name|title)d "([^"]+)"$/ do |model, attribute, value|
  model = model.classify.constantize
  attributes = { attribute => value }
  attributes[:site_id]    = site.id    if model.column_names.include?('site_id')
  attributes[:account_id] = account.id if model.column_names.include?('account_id')
  model.find(:first, :conditions => attributes) || model.create!(attributes)
end

# e.g. a post with the title "Post" for the blog "Blog"
Given /^an? (.*) with the (\w+) "([^"]+)" for the (\w+) "([^"]+)"$/ do |model, attribute, value, section, name|
  section = Given(%(a #{section} named "#{name}"))
  collection = section.send(model.underscore.pluralize)
  attributes = { attribute => value }
  collection.find(:first, :conditions => attributes) || collection.create!(attributes)
end

When /^I (press|click) "(.*)" in the row where "(.*)" is "(.*)"$/ do |method, link_or_button, header, cell_content|
  body = Nokogiri::HTML(response.body)
  header_id = body.xpath("//th[normalize-space(text())='#{header}']/@id").first.value
  row_id = body.xpath("//tr/td[@headers='#{header_id}'][normalize-space(text())='#{cell_content}']/ancestor::tr/@id").first.value
  within("##{row_id}") do
    send({'press' => 'click_button', 'click' => 'click_link'}[method], link_or_button)
  end
end

When /^I click on the link from the email to (.*)$/ do |to|
  email = ::ActionMailer::Base.deliveries.detect { |email| email.to.include?(to) }
  assert email, "email to #{to} could not be found"
  link = email.body.to_s =~ %r((http://[^\s"]+)) && $1
  get link
end

Then /^the title should be "([^"]*)"$/ do |title|
  assert_select('title', title)
end

# Then /^I should see $/ do
#   # do nothing
# end

Then /^I should not see any (\w*)$/ do |type|
  assert_select(".#{type.singularize}", :count => 0) # .#{type},
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

Then /^I should see an? ([\w]*) list$/ do |type|
  assert_select(".#{type}.list")
end

Then /^I should see an? ([a-z ]+) form$/ do |type|
  type = type.gsub(' ', '_') #.gsub(/edit_/, '')
  assert_select("form.#{type}, form##{type}")
end

Then /^I should not see an? ([a-z ]+) form$/ do |type|
  type = type.gsub(' ', '_') #.gsub(/edit_/, '')
  assert_select("form.#{type}, form##{type}", :count => 0)
end

Then /^I should see an? ([a-z ]+) form with the following values:$/ do |type, table|
  type = type.gsub(' ', '_') #.gsub(/edit_/, '')
  assert_select("form.#{type}, form##{type}") do |form|
    table.rows_hash.each do |name, value|
      assert_equal value, webrat.current_scope.field_labeled(name).value
    end
  end
end

Then /^I should see a "(.*)" table with the following entries$/ do |table_id, expected_table|
  actual_table = table(tableish("table##{table_id} tr", 'td,th'))
  begin
    diff_table = expected_table.dup
    diff_table.diff!(actual_table.dup)
  rescue
    puts "\nActual table:#{actual_table.to_s}\n"
    puts "Expected table:#{expected_table.to_s}\n"
    puts "Difference:#{diff_table.to_s}\n"
    raise
  end
end

Then /^I should see the "([^"]+)" page$/ do |name|
  assert_select('h2', name)
end

Then(/(?:\$|eval) (.*)$/) do |code|
  pp eval(code)
end

Then /^I should see a flash (error|notice|message) "(.*)"$/ do |message_type, message|
  assert_match message, flash_cookie[message_type].to_s
end

Then /^I should not see a flash (error|notice) "(.*)"$/ do |message_type, message|
  assert_no_match /message/, flash_cookie[message_type].to_s
end

Then /^the following emails should have been sent:$/ do |expected_emails|
  expected_emails.hashes.each do |attributes|
    assert_email_sent(attributes)
  end
end
