When /^(?:|I )have visited (.+)$/ do |page|
  visit path_to(page)
  follow_redirect! if redirect?
end

When /^the following urls are tagged:$/ do |table|
  table.hashes.each do |attributes|
    url = "http://www.example.com#{attributes[:url]}"
    attributes[:tags].split(',').map(&:strip).each do |tag|
      Rack::Cache::Tags::Store::ActiveRecord::Tagging.create!(:tag => tag, :url => url)
    end
  end
end

Then /^the following urls should be tagged:$/ do |table|
  table.hashes.each do |hash|
    url = "http://www.example.com#{hash[:url]}"
    actual = Rack::Cache::Tags::Store::ActiveRecord::Tagging.where(:url => url).map(&:tag)
    expected = hash[:tags].split(',').map(&:strip)
    assert_equal expected, expected & actual
  end
end

When /I don't follow any http redirects/ do
  pending 'disable following of redirects'
end

Then /^it should purge cache entries tagged: (.+)$/ do |tags|
  expected = tags.split(',').map(&:strip)
  actual = response.headers[Rack::Cache::Tags::PURGE_TAGS_HEADER]
  assert actual, 'no purge tags headers found'
  assert_equal expected.sort, actual.split("\n").sort
end

Then /^it should purge the cache entries: (.+)$/ do |urls|
  expected = urls.split(',').map(&:strip).sort
  actual = response.headers[Rack::Cache::Purge::PURGE_HEADER]
  assert actual, 'no purge headers found'
  actual = actual.split("\n").map { |url| url.sub('http://www.example.com', '') }.sort
  assert_equal expected, actual, "did not purge the expected urls.\n expected: #{expected.inspect}\n actual: #{actual.inspect}"
end
