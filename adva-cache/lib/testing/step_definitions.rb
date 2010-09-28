Then /^the following urls should be tagged:$/ do |table|
  table.hashes.each do |hash|
    url = "http://www.example.com#{hash[:url]}"
    actual = Rack::Cache::Tags::Store::ActiveRecord::Tagging.where(:url => url).map(&:tag)
    expected = hash[:tags].split(',').map(&:strip)
    assert_equal expected, expected & actual
  end
end
