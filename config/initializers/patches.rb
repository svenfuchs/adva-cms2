Dir[File.expand_path('../../../lib/patches/**/*.rb', __FILE__)].each do |file|
  require file
end