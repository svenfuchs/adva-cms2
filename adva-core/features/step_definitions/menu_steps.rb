Then /^the menu should contain the following items:$/ do |menu|
  menu.hashes.each do |item|
    assert_select('.menu li a[href=?]', item['url'], item['text'])
  end
end