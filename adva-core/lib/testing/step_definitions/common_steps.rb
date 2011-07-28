Then /^the "([^\"]*)" field should be empty$/ do |field|
  if defined?(Spec::Rails::Matchers)
    field_labeled(field).value.should be_blank
  else
    assert field_labeled(field).value.blank?
  end
end

Given 'a site' do
  @site = Factory(:site)
end

# Examples:
# 1. Given the following products:
# Also supports namespaced models, (cnet) indicating the namespace Cnet
# 2. Given the following (cnet) products:
Given /^the following ((?:\([a-z ]+\) )?(?:[\w]+)):$/ do |type, table|
  type = type.gsub(/^\(([a-z ]+)\) /, "\\1/").gsub(' ', '_').singularize
  table.hashes.each do |attributes|
    type = attributes.delete('type').underscore if attributes.key?('type')
    attributes['site'] = site if type.classify.constantize.column_names.include?('site_id')
    parent = attributes.delete('parent')
    attributes['parent_id'] = type.classify.constantize.find_by_name(parent) unless parent.blank?
    Factory(type, attributes)
  end
end

Given /^the (\w+) "([^"]*)" is a child of "([^"]*)"$/ do |model, child, parent|
  model  = model.classify.constantize
  parent = model.find_by_name(parent)
  child  = model.find_by_name(child)
  child.move_to_child_of(parent)
end

Given /^a site with the following sections:$/ do |table|
  Site.all.map(&:destroy)
  @site = Factory(:site, :sections_attributes => [])
  Given "the following sections:", table
end

Given /^a site with a (\w+) named "([^"]+)"$/ do |section, name|
  Site.all.map(&:destroy)
  @site = Factory(:site, :sections_attributes => [])
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

# e.g. a post titled "Post" for the blog "Blog"
# e.g. a category named "Category" belonging to the blog "Blog"
Given /^an? (\w+) (name|title)d "([^"]+)" (?:for|belonging to) the (\w+) "([^"]+)"$/ do |model, attribute, value, section, name|
  section = Given(%(a #{section} named "#{name}"))
  collection = section.send(model.underscore.pluralize)
  attributes = { attribute => value }
  collection.where(attributes).first || collection.create!(attributes)
end

# e.g. a post with the title "Post" for the blog "Blog"
# e.g. a post with the title "Post" belonging to the blog "Blog"
Given /^an? (\w+) with the (\w+) "([^"]+)" (?:for|belonging to) the (\w+) "([^"]+)"$/ do |model, attribute, value, section, name|
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

When /^I (press|click|follow) "(.*)" in the row (of the ([a-z ]+) table )?where "(.*)" is "(.*)"$/ do |action, target, _, table_id, header, content|
  table_id =  table_id.gsub(/ /, '_') unless table_id.nil?
  table_xpath = table_id.nil? ? 'table' : "table[@id='#{table_id}']"
  headers = page.all(:xpath, "//#{table_xpath}/descendant::th[normalize-space(text())='#{header}']")
  assert !headers.empty?, "could not find table header cell #{header.inspect}"

  header_id = headers.first['id']
  cell_path = "//#{table_xpath}/descendant::td[@headers='#{header_id}']"
  content   = "normalize-space(text())='#{content}'"
  tag_path  = "#{cell_path}[#{content}]/ancestor::tr"
  nested_tag_path = "#{cell_path}/descendant::*[#{content}]/ancestor::tr"

  rows = page.all(:xpath, [tag_path, nested_tag_path].join('|'))
  assert !rows.empty?, "could not find table row where a cell has the header id #{header_id.inspect} and the content #{content.inspect}"

  map = { 'press' => 'click_button', 'click' => 'click_link' }
  if table_id.nil?
    within("##{rows.first['id']}") { map[action] ? send(map[action], target) : When(%(I #{action} "#{target}")) }
  else
    within("table##{table_id} ##{rows.first['id']}") { map[action] ? send(map[action], target) : When(%(I #{action} "#{target}")) }
  end
end

# Examples:
# I should see a product row where "Name" is "Apple Powerbook"
# I should not see a product row where "Name" is "Apple Powerbook"
# I should see a row in the products table where "Name" is "Apple Powerbook"
Then /^I should (not )?see a ([a-z ]+ )?row (?:of the ([a-z ]+) table )?where "(.*)" is "(.*)"$/ do |optional_not, row_classes, table_id, header, cell_content|
  table_xpath = table_id.nil? ? 'table' : "table[@id='#{table_id.gsub(/ /, '_')}' or @id='#{table_id.gsub(/ /, '-')}']"
  table_header_cells = page.all(:xpath, "//#{table_xpath}/descendant::th[normalize-space(text())='#{header}']")

  unless optional_not.present?
    assert !table_header_cells.empty?, "could not find table header cell '#{header}'"
  end
  header_id = table_header_cells.first['id']

  class_condition = row_classes.to_s.split(' ').map do |row_class|
    "contains(concat(' ', normalize-space(@class), ' '), ' #{row_class} ')"
  end.join(' and ')
  tr_xpath = class_condition.empty? ? 'ancestor::tr' : "ancestor::tr[#{class_condition}]"
  final_path = "//#{table_xpath}/descendant::td[@headers='#{header_id}'][normalize-space(text())='#{cell_content}']/#{tr_xpath}"

  if optional_not.present?
    assert page.has_no_xpath?(final_path), "Expected not find a row where #{header.inspect} is #{cell_content}."
  else
    assert page.has_xpath?(final_path), "Expected to find at least one row where #{header.inspect} is #{cell_content}."
  end
end

Then /^there should be an? (\w+)$/ do |model|
  assert @last_record = model.classify.constantize.first, "could not find any #{model}"
end

Then /^there should be an? (\w+) named "([^\"]+)"$/ do |model, name|
  assert @last_record = model.classify.constantize.where(:name => name).first, "could not find any #{model} named #{name}"
end

Then /^there should not be an? (\w+) named "([^"]*)"$/ do |model, name|
  assert !model.classify.constantize.where(:name => name).first, "expected no #{model} named #{name} exists, but found one"
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
  Then %Q{I should see "#{title}" within "title"}
end

# TODO: This is an almost duplicate step
# Use the one with un-quoted 'thing' expression
Then /^I should see (an?|the) "([^"]+)"$/ do |kind, thing|
  kind = { 'a' => '.', 'the' => '#' }[kind]
  assert page.has_css?("#{kind}#{thing}")
end

Then /^I should see a link "([^"]+)"$/ do |link|
  @last_link = link
  assert page.has_css?('a', :text => link)
end

Then /^I should not see any ([a-z_ ]+)$/ do |type|
  assert page.has_no_css?(".#{type.gsub(' ', '_').singularize}")
end

# FIXME: this step and the ones above do not deal with use perception
#  for example: "I should see a fn0rd" looks nice, but users cannot see elements, only text
Then /^I should see an? (\w+)$/ do |type|
  assert page.has_css?(".#{type}")
end

Then /^I should see a "([^"]*)" select box with the following options:$/ do |name, options|
  field = find_field(name)
  actual = field.all(:css, 'option').map {|o| o.text }
  expected = options.raw.flatten[1..-1] # ignores the first row
  assert_equal expected, actual
end

Then /^I should see an? (\w+) (?:titled|named) "([^"]+)"$/ do |thingy, text|
  Then %Q~I should see "#{text}" within ".#{thingy} h2"~
end

Then /^I should see an? (\w+) containing "([^"]+)"$/ do |thingy, text|
  Then %Q~I should see "#{text}" within ".#{thingy}"~
end

Then /^I should see an? (\w+) list$/ do |type|
  assert page.has_css?(".#{type}.list")
end

Then /^I should see a list of (\w+)$/ do |type|
  assert page.has_css?(".#{type}.list")
end

Then /^the (.*) list should display (.*)s in the following order:$/ do |list, model, values|
  expected = values.raw.flatten
  name     = expected.shift
  selector = "##{list}.list tr td.#{name}"
  rows     = parsed_html.css(selector)

  assert !rows.empty?, "could not find any elements matching #{selector.inspect}"
  assert_equal expected, rows.map(&:content)
end

Then /^I should see an? ([a-z ]+) form$/ do |type|
  tokens = type.split(' ')
  types = [tokens.join('_'), tokens.reverse.join('_')]
  selectors = types.map { |type| "form.#{type}, form##{type}" }
  assert page.has_css?(selectors.join(', '))
end

Then /^I should not see an? ([a-z ]+) form$/ do |type|
  type = type.gsub(' ', '_') #.gsub(/edit_/, '')
  assert page.has_no_css?("form.#{type}, form##{type}")
end

Then /^I should see an? ([a-z ]+) form with the following values:$/ do |kind, table|
  with_scope("#{kind} form") do
    table.rows_hash.each do |name, value|
      Then %Q~the "#{name}" field should contain "#{value}"~
    end
  end
end

Then /^I should see a "(.+)" table with the following entries:$/ do |dom_id, expected|
  actual = table(tableish("table##{dom_id} tr", 'th,td'))
  expected.diff! actual
end

Then /^I should see a "(.+)" list with the following entries:$/ do |dom_id, expected|
  value_selector = expected.column_names.map {|n| '.' + n.downcase.gsub(/[ _]/, '-') }.join(',')
  list = tableish("ul##{dom_id} li", value_selector)
  actual = table( [expected.column_names] + list )
  actual.column_names.each do |col|
    actual.map_column!(col) { |text| text.sub(/\n/,' ') }
  end
  expected.diff! actual
end

Then /^I should see a "(.+)" table with the following entries in no particular order:$/ do |table_id, expected_table|
  actual_table  = table(tableish("table##{table_id} tr", 'td,th'))
  expected_rows = expected_table.raw
  actual_rows   = actual_table.raw.transpose.select { |row| expected_rows.first.include?(row.first) }.transpose
  assert_equal expected_rows.to_set, actual_rows.to_set, tables_differ_message(actual_table, expected_table)
end

def tables_differ_message(actual, expected, diff = nil)
  msg = "\nActual table:#{actual.to_s}\nExpected table:#{expected.to_s}\n"
  msg += "Difference:#{diff.to_s}\n" if diff
  msg
end

Then /^I should see the "([^"]+)" page$/ do |name|
  Then %Q~I should see "#{name}" within "h2"~
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
  selector = "*[id*=#{model.downcase.gsub(' ', '_')}_#{attribute.downcase.gsub(' ', '_')}] + span.error"
  Then %Q~I should #{should_see} "#{error_msg}" within "#{selector}"~
end

Then /^the following emails should have been sent:$/ do |expected_emails|
  expected_emails.hashes.each do |attributes|
    assert_email_sent(attributes)
  end
end

Then /^no emails should have been sent$/ do
  assert_no_email_sent
end

Then /^"([^"]*)" should be filled in with "([^"]*)"$/ do |field, value|
  field = find_field(field)
  field_value = (field.tag_name == 'textarea') ? field.text : field.value
  assert_equal(value, field_value)
end

Then /^"([^"]*)" should (be|not be) checked$/ do |label, be_or_not_to_be|
  Then %Q{the "#{label}" checkbox should #{be_or_not_to_be} checked}
end

Then /^"([^"]*)" should be selected as "([^"]*)"$/ do |value, label|
  select_box = find_field(label)
  selected = select_box.find(:xpath, ".//option[@selected = 'selected']")
  assert_equal value, selected.text
end

Then /^I should see "([^"]*)" formatted as a "([^"]*)" tag$/ do |value, tag|
  Then %Q~I should see "#{value}" within "#{tag}"~
end

# TODO remove the manual (?: in..) to leverage cucumber selectors
Then(/^I should see (\d+|no|one|two|three) ([-a-z ]+?)(?: in (the [a-z -]+))?$/) do |amount, item_class, container|
  amount = case amount
    when 'no' then 0
    when 'one' then 1
    when 'two' then 2
    when 'three' then 3
    else amount.to_i
  end
  item_selector = '.' + item_class.gsub(' ', '_').singularize
  with_scope container do
    assert page.has_css?(item_selector,:count => amount)
  end
end

Then /^the "([^"]*)" radio button should (be|not be) checked$/ do |label, be_or_not_to_be|
  Then %Q~the "#{label}" checkbox should #{be_or_not_to_be} checked~
end

Then /^(?:|I )should not be on (.+)$/ do |page_name|
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should_not == path_to(page_name)
  else
    assert_not_equal path_to(page_name), current_path
  end
end



