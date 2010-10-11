# Examples for using this step:
# 1. Given the following images for the product named "Wireless Keyboard":
# 2. Given the following videos for bundle titled "Cool Bundle":
# 3. Given the following (cnet) digital_contents for the (cnet) product named "MacBook pro":
Given /^the following ((?:\([a-z ]+\) )?(?:[\w_]+)) for (?:the )?((?:\([a-z ]+\) )?(?:[\w ]+)) ([\w]+)d "([^"]*)":$/ do |type, assetable, name_or_title, value, table|
  Given "the following #{type} for the #{assetable} with #{name_or_title} \"#{value}\":", table
end


# Examples for using this step:
# 1. Given the following images for the product with name "Wireless Keyboard":
# 2. Given the following videos for bundle with title "Cool Bundle":
# 3. Given the following (cnet) digital_contents for the (cnet) product with name "MacBook pro":
#Given /^the following ((?:\([a-z ]+\) )?(?:[\w ]+)) for (?:the )?((?:\([a-z ]+\) )?(?:[\w ]+)) with ([\w ]+) "([^"]*)":$/ do |type, assetable, attribute, value, table|
Given /^the following ((?:\([a-z ]+\) )?(?:[\w_]+)) for (?:the )?((?:\([a-z ]+\) )?(?:[\w ]+)) with ([\w ]+) "([^"]*)":$/ do |type, assetable, attribute, value, table|
  paths = {
    'images'                  => 'test/fixtures/rails.png',
    'videos'                  => 'test/fixtures/sample_video.swf'
  }
  attribute = attribute.gsub(' ', '_')
  assetable = assetable.gsub(/^\(([a-z ]+)\) /, "\\1/").gsub(' ', '_').classify.constantize.where(attribute => value).first
  table.hashes.each do |attributes|
    assetable.send(type.gsub(/[()]/, '').gsub(' ', '_')).create!(attributes.merge(
        :file => File.open(Adva::Assets.root.join(paths[type])),
        :site => Site.first
      )
    )
  end
end

def asset_tag_titled(type, title)
  xpaths = {
    :image => "//img[@alt='#{title}']",
    # TODO does not actually return the object tag, but the param tag
    :video => "//param[@name='name' and @value='#{title}']/parent::object/child::param[@name='movie']"
  }
  assert xpath = xpaths[type.to_sym], "undefined type #{type}"
  Nokogiri::HTML(response.body).xpath(xpath).first
end

def button_for(tag)
  body = Nokogiri::HTML(response.body)
  # TODO should also be able to match buttons in tr/tds
  body.xpath("#{tag.path}/ancestor::li/descendant::input[@type='submit']").first
end

When /^I press the delete button for ([\w ]+) with title "([^"]*)"$/ do |type, title|
  asset = asset_tag_titled(type, title)
  button = button_for(asset)
  click_button(button['id'])
end

Then /^I should see the (image|video) "([^"]*)"$/ do |type, title|
  asset = asset_tag_titled(type, title)
  assert asset, "could not find an #{type} with the title '#{title}'"
  src_attributes = { :image => 'src', :video => 'value' }
  src = asset.attributes[src_attributes[type.to_sym]].value
  assert File.exists?(src), "The source file #{src.inspect} for #{type} #{title.inspect} does not exist"
end

Then /^I should not see the (image|video) "([^"]*)"$/ do |type, title|
  asset = asset_tag_titled(type, title)
  assert_nil asset, "expected the #{type} with title #{title.inspect} not be found, but was found"
end

