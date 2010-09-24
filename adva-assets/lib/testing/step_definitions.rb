Then /^I should see the image "([^"]*)"$/ do |image_title|
  body = Nokogiri::HTML(response.body)
  images = body.xpath("//img[@alt='#{image_title}']")
  assert images.one?, "image with title '#{image_title}' could not be found"
  image_src = images.first.attributes["src"].value
  # The current carrierwave gem at master stores files with file names in the format 'filename_of_uploaded_file?1234325123' with
  # the suffix '?' + some random integer value.
  # As we patched webrat to make file uploads work (see adva-core/lib/patches/webrat/upload_file.rb) and because this patch always
  # stores a file with name 'rails.png', we need to strip that suffix to be able to check if the file can be found:
  Rails.root.join('public', image_src).to_s =~ /\/(.*)\?.*/
  file_url = Rails.root.join('public', $1)
  assert File.exists?(file_url), "file '#{file_url}' for image '#{image_title}' does not exist"
end

Then /^I should see the video "([^"]*)"$/ do |video_title|
  body = Nokogiri::HTML(response.body)
  videos = body.xpath("//param[@name='name' and @value='#{video_title}']/parent::object/child::param[@name='movie']")
  assert videos.one?, "video with title '#{video_title}' could not be found"
  video_src = videos.first.attributes["value"].value
  file_url = Rails.root.to_s + '/public' + video_src
  assert File.exists?(file_url), "file '#{file_url}' for video '#{video_title}' does not exist"
end