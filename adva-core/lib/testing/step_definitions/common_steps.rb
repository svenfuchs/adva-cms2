Given 'a site' do
  @site = Factory(:site)
  Factory(:admin)
end

Given /^the following (\w+):$/ do |type, table|
  type = type.singularize
  table.hashes.each do |attributes|
    type = attributes.delete('type').underscore if attributes.key?('type')
    attributes['site'] = site if type.classify.constantize.column_names.include?('site_id')
    Factory(type, attributes)
  end
end

Given /^a site with the following sections:$/ do |table|
  Site.all.map(&:destroy)
  Given 'a site'
  Section.all.map(&:destroy)
  Given "the following sections:", table
end

Given /^a site with a (\w+) named "([^"]+)"$/ do |section, name|
  Site.delete_all
  Given 'a site'
  Section.delete_all
  Given %(a #{section} named "#{name}")
end

# e.g. a blog named "Blog"
Given /^an? (\w+) (name|title)d "([^"]+)"$/ do |model, attribute, value|
  model = model.classify.constantize
  attributes = { attribute => value }
  attributes[:site_id]    = site.id    if model.column_names.include?('site_id')
  attributes[:account_id] = account.id if model.column_names.include?('account_id')
  model.where(attributes).first || model.create!(attributes)
end

Given /^an? (\w+) with the following attributes:$/ do |model, table|
  Factory(model, table.rows_hash)
end

# e.g. a post with the title "Post" for the blog "Blog"
Given /^an? (\w+) with the (\w+) "([^"]+)" for the (\w+) "([^"]+)"$/ do |model, attribute, value, section, name|
  section = Given(%(a #{section} named "#{name}"))
  collection = section.send(model.underscore.pluralize)
  attributes = { attribute => value }
  collection.where(attributes).first || collection.create!(attributes)
end

Given /^(\w+)s with the following attributes:$/ do |model, table|
  table.hashes.each do |attributes|
    Factory(model, attributes)
  end
end

When /^(.+) that link$/ do |step|
  raise "no last link" if @last_link.blank?
  When %(#{step} "#{@last_link}")
end

When /^I (press|click) "(.*)" in the row (of the ([a-z ]+) table )?where "(.*)" is "(.*)"$/ do |press_or_click, link_or_button, _, table_id, header, cell_content|
  body = Nokogiri::HTML(response.body)
  table_xpath = table_id.nil? ? 'table' : "table[@id='#{table_id.gsub(/ /, '_')}']"
  header_id = body.xpath("//#{table_xpath}/descendant::th[normalize-space(text())='#{header}']/@id").first.value
  row_id = body.xpath("//#{table_xpath}/descendant::td[@headers='#{header_id}'][normalize-space(text())='#{cell_content}']/ancestor::tr/@id").first.value
  within("##{row_id}") do
    send({'press' => 'click_button', 'click' => 'click_link'}[press_or_click], link_or_button)
  end
end

When /^I click on the link from the email to (.*)$/ do |to|
  email = ::ActionMailer::Base.deliveries.detect { |email| email.to.include?(to) }
  assert email, "email to #{to} could not be found"
  link = email.body.to_s =~ %r((http://[^\s"]+)) && $1
  get link
end

Then /^there should be an? (\w+)$/ do |model|
  assert @last_record = model.classify.constantize.first, "could not find any #{model}"
end

Then /^there should be an? (\w+) named "([^\"]+)"$/ do |model, name|
  assert @last_record = model.classify.constantize.where(:name => name).first, "could not find any #{model} named #{name}"
end

Then /^there should be a (\w+) with the following attributes:$/ do |model, table|
  assert @last_record = model.classify.constantize.where(table.rows_hash).first, "could not find a #{model} with #{table.rows_hash.inspect}"
end

Then /^there should be (\w+)s with the following attributes:$/ do |model, table|
  table.hashes.each do |attributes|
    assert model.classify.constantize.where(attributes).first, "could not find a #{model} with #{attributes.inspect}"
  end
end

Then /^that (\w+) should have an? (\w+) with the following attributes:$/ do |last, model, table|
  assert @last_record.is_a?(last.classify.constantize), "wrong type for last #{last}"
  assert @last_record.send(model.pluralize).where(table.rows_hash).first, "could not find a #{model} with #{table.rows_hash.inspect}"
end

Then /^that (\w+) should have (\w+)s with the following attributes:$/ do |last, model, table|
  assert @last_record.is_a?(last.classify.constantize), "wrong type for last #{last}"
  table.hashes.each do |attributes|
    assert @last_record.send(model.pluralize).where(attributes).first, "could not find a #{model} with #{attributes.inspect}"
  end
end

Then /^the title should be "([^"]+)"$/ do |title|
  assert_select('title', title)
end

Then /^I should see a link "([^"]+)"$/ do |link|
  @last_link = link
  assert_select('a', link)
end

Then /^I should not see any (\w+)$/ do |type|
  assert_select(".#{type.singularize}", :count => 0) # .#{type},
end

Then /^I should see an? (\w+)$/ do |type|
  assert_select(".#{type}")
end

Then /^I should see an? (\w+) (?:titled|named) "([^"]+)"$/ do |type, text|
  assert_select(".#{type} h2", text)
end

Then /^I should see an? (\w+) containing "([^"]+)"$/ do |type, text|
  assert_select(".#{type}", /#{text}/)
end

Then /^I should see an? (\w+) list$/ do |type|
  assert_select(".#{type}.list")
end

Then /^I should see a list of (\w+)$/ do |type|
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

Then /^I should see a "(.+)" table with the following entries:$/ do |table_id, expected_table|
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

Then /^I should see a flash (error|notice|message) "(.+)"$/ do |message_type, message|
  assert_match message, flash_cookie[message_type].to_s
end

Then /^I should not see a flash (error|notice) "(.+)"$/ do |message_type, message|
  assert_no_match /message/, flash_cookie[message_type].to_s
end

Then /^I should (see|not see) the error "([^"]+)" for attribute "([^"]+)" of the "([^"]+)"$/ do |should_see, error_msg, attribute, model|
  if should_see == 'see' # ugh ...
    assert_select "*[id*=#{model.downcase.gsub(' ', '_')}_#{attribute.downcase.gsub(' ', '_')}] + span.error",
      :text => error_msg
  elsif should_see == 'not see'
    assert_select "*[id*=#{model.downcase.gsub(' ', '_')}_#{attribute.downcase.gsub(' ', '_')}] + span.error",
      :text => error_msg, :count => 0
  end
end

Then /^the following emails should have been sent:$/ do |expected_emails|
  expected_emails.hashes.each do |attributes|
    assert_email_sent(attributes)
  end
end

# Then /^I should see a "([^"]+)" table with the following entries:$/ do |table_id, expected_table|
#   html_table = table(tableish("table##{table_id} tr", 'td,th'))
#   expected_table.diff!(html_table)
# end

# Then I should see a comment within the sidebar
# Will look for '#sidebar .comment'
# Then I should see the cart within the sidebar
# Will look for '#sidebar #cart'
Then /^I should see (an?|the) ([a-z ]+) within the ([a-z ]+)$/ do |a_or_the, selector, context_selector|
  within("##{context_selector}") do |context|
    assert_select({'a' => '.', 'the' => '#'}[a_or_the]+selector)
  end
end

Then /^"([^"]*)" should be filled in with "([^"]*)"$/ do |field, value|
  field = webrat.field_labeled(field)
  assert_equal value, field.value
end

Then /^"([^"]*)" should be selected as "([^"]*)"$/ do |value, select|
  select = webrat.field_labeled(select)
  assert_equal value, select.element.xpath(".//option[@selected = 'selected']").first.text
end

Then /^I should see "([^"]*)" formatted as a "([^"]*)" tag$/ do |value, tag|
  assert_select(tag, value)
end


Then "debug" do
  debugger
  true
end
