Then /^the menu should contain the following items:$/ do |menu|
  menu.hashes.each do |item|
    if item['url'].empty?
      assert_select("#{item[:menu]} li h4", item['text'])
    else
      active = item[:active] == 'yes' ? '.active' : ':not(.active)'
      url    = item['url'].gsub(/\d+/, '[\d]*').gsub('?', '\?')
      assert_select("#{item[:menu]} li#{active} a[href=?]", %r(#{url}), item['text'])
    end
  end
end
