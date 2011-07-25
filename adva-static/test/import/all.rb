Dir[File.expand_path('../**/*_test.rb', __FILE__)].each do |file|
  require file
end
