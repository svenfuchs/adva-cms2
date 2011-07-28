Then /^the menu should contain the following items:$/ do |menu|
  menu.hashes.each do |item|
    if item['url'].empty?
      assert page.has_css?("#{item[:menu]} li h4", :text => item['text'])
    else
      active = item[:active] == 'yes' ? '.active' : ':not(.active)'
      url    = item['url'].gsub('?', '\?').gsub('[', '\[').gsub(']', '\]').gsub(/\d+/, '[\d]*')
      url_matcher = %r(#{url})
      menu = item[:menu] || 'body'
      links = page.all(:css, "#{menu} li#{active} a", :text => item['text']).select do |a|
        a['href'] =~ url_matcher
      end
      assert !links.empty?
    end
  end
end
