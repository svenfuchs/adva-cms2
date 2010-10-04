Then /^I should (not )?see the image "([^"]*)"$/ do |not_see, image_title|
  body = Nokogiri::HTML(response.body)
  images = body.xpath("//img[@alt='#{image_title}']")
  if not_see
    assert images.empty?, "expected the image with title '#{image_title}' not be found, but was found"
  else
    assert images.one?, "image with title '#{image_title}' could not be found"
    image_src = images.first.attributes["src"].value
    assert File.exists?(image_src), "file '#{image_src}' for image '#{image_title}' does not exist"
  end
end

Then /^I should (not )?see the video "([^"]*)"$/ do |not_see, video_title|
  body = Nokogiri::HTML(response.body)
  videos = body.xpath("//param[@name='name' and @value='#{video_title}']/parent::object/child::param[@name='movie']")
  if not_see
    assert videos.empty?, "expected the video with title '#{video_title}' not be found, but was found"
  else
    assert videos.one?, "video with title '#{video_title}' could not be found"
    video_src = videos.first.attributes["value"].value
    assert File.exists?(video_src), "file '#{video_src}' for video '#{video_title}' does not exist"
  end
end

When /^I press the delete button for ([a-z ]+) with title "([^"]*)"$/ do |asset_type, asset_title|
  body = Nokogiri::HTML(response.body)
  assets = if asset_type == 'image'
    body.xpath("//img[@alt='#{asset_title}']/parent::li/descendant::input[@type='submit']/@id")
  else
    body.xpath("//param[@name='name' and @value='#{asset_title}']/parent::object/parent::li/descendant::input[@type='submit']/@id")
  end
  assert assets.one?, "#{asset_type} with title '#{asset_title}' could not be found"
  check_box_id = assets.first.value
  click_button check_box_id
end

# Examples for using this step:
# 1. Given the following images for product named "Wireless Keyboard":
# 2. Given the following videos for bundle titled "Cool Bundle":
Given /^the following ([a-z ]+) for ([a-z ]+) ([a-z]+)d "([^"]*)":$/ do |asset_association, assetable_type, attribute, attribute_value, table|
  paths = {
    'images' => 'test/fixtures/rails.png',
    'videos' => 'test/fixtures/sample_video.swf'
  }
  assetable = assetable_type.gsub(/ /, '_').classify.constantize.where(attribute => attribute_value).first
  table.hashes.each do |attributes|
    assetables.send(asset_association).create!(attributes.merge(
        :file => File.open(Adva::Assets.root.join(paths[type])),
        :site => Site.first
      )
    )
  end
end