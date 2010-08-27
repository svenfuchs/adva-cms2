
Given /^the following (images):$/ do |asset, table|
  @asset_path = File.expand_path("../../../adva-assets/test/fixtures/rails.png", __FILE__)
  table.hashes.each do |attributes|
    attributes[:site] = current_site
    attributes[:file] = File.open(@asset_path)
    
    Asset.create!(attributes)
  end
end