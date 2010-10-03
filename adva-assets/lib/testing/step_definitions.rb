Then /^I should (not )?see the image "([^"]*)"$/ do |see, image_title|
  body = Nokogiri::HTML(response.body)
  images = body.xpath("//img[@alt='#{image_title}']")
  if see
    assert images.empty?, "expected the image with title '#{image_title}' not be found, but was found"
  else
    assert images.one?, "image with title '#{image_title}' could not be found"
    image_src = images.first.attributes["src"].value
    assert File.exists?(image_src), "file '#{image_src}' for image '#{image_title}' does not exist"
  end
end

Then /^I should see the video "([^"]*)"$/ do |video_title|
  body = Nokogiri::HTML(response.body)
  videos = body.xpath("//param[@name='name' and @value='#{video_title}']/parent::object/child::param[@name='movie']")
  assert videos.one?, "video with title '#{video_title}' could not be found"
  video_src = videos.first.attributes["value"].value
  assert File.exists?(video_src), "file '#{video_src}' for video '#{video_title}' does not exist"
end

When /^I press the delete button for image with title "([^"]*)"$/ do |image_title|
  body = Nokogiri::HTML(response.body)
  check_box_id = body.xpath("//img[@alt='#{image_title}']/parent::li/descendant::input[@type='submit']/@id").first.value
  assert check_box_id.one?, "delete button for image with title '#{image_title}' could not be found"
  click_button check_box_id
end

Given /^the following (assets|images|videos) for the (\w+) (\w+)d "([^"]*)":$/ do |type, assetable, attribute, value, table|
  paths = {
    'images' => 'test/fixtures/rails.png'
  }
  raise "gotta define a fixture for #{type.inspect}" unless paths[type]
  assetable = assetable.classify.constantize.where(attribute => value).first
  table.hashes.each do |attributes|
    assetable.send(type).create!(attributes.merge(
      :file => File.open(Adva::Assets.root.join(paths[type])),
      :site => Site.first
    ))
  end
end
