# Examples for using this step:
# 1. Given the following images for the product named "Wireless Keyboard":
# 2. Given the following videos for bundle titled "Cool Bundle":
Given /^the following ([\w ]+) for (?:the )?([\w ]+) ([\w]+)d "([^"]*)":$/ do |type, assetable, name, value, table|
  paths = {
    'images' => 'test/fixtures/rails.png',
    'videos' => 'test/fixtures/sample_video.swf'
  }
  assetable = assetable.gsub(/ /, '_').classify.constantize.where(name => value).first
  table.hashes.each do |attributes|
    assetable.send(type).create!(attributes.merge(
        :file => File.open(Adva::Assets.root.join(paths[type])),
        :site => Site.first
      )
    )
  end
end

def asset_tag_titled(type, title)
  xpaths = {
    :image => "//img[@alt='#{title}']",
    :video => "//param[@name='name' and @value='#{title}']/parent::object/child::param[@name='movie']"
  }
  assert xpath = xpaths[type.to_sym], "undefined type #{type}"
  Nokogiri::HTML(response.body).xpath(xpath).first
end

def button_for(tag)
  body = Nokogiri::HTML(response.body)
  body.xpath("#{tag.path}/parent::li/descendant::input[@type='submit']").first
end

When /^I press the delete button for ([\w ]+) with title "([^"]*)"$/ do |type, title|
  asset = asset_tag_titled(type, title)
  button = button_for(asset)
  click_button(button['id'])
end

Then /^I should see the (image|video) "([^"]*)"$/ do |type, title|
  asset = asset_tag_titled(type, title)
  assert asset, "could not find an #{type} with the title '#{title}'"
  src = asset.attributes["src"].value
  assert File.exists?(src), "The source file #{src.inspect} for #{type} #{title.inspect} does not exist"
end

Then /^I should not see the (image|video) "([^"]*)"$/ do |type, title|
  asset = asset_tag_titled(type, title)
  assert_nil asset, "expected the #{type} with title #{title.inspect} not be found, but was found"
end

