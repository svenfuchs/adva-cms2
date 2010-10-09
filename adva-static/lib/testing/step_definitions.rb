After do
  import_dir.rmtree rescue Errno::ENOENT if import_dir
  export_dir.rmtree rescue Errno::ENOENT if export_dir
end

Given /^an empty import directory "([^"]+)"$/ do |name|
  @import_dir = Pathname.new("/tmp/adva-static-test/import/#{name}")
  import_dir.mkpath
end

Given /^an empty export directory$/ do
  @export_dir = Pathname.new("/tmp/adva-static-test/export")
  export_dir.mkpath
end

Given /^a source file "([^\"]*)" with the following values:$/ do |filename, hash|
  setup_files([filename, YAML.dump(hash.rows_hash)]) unless filename.blank?
end

Given /^a source file "([^\"]*)"$/ do |filename|
  setup_files([filename, '']) unless filename.blank?
end

Given /^the following source files:$/ do |table|
  table.hashes.each do |hash|
    setup_files([hash.delete('file'), YAML.dump(hash)])
  end
end

Given /^a watcher has started$/ do
  @watch ||= begin
    Adva::Static::Rack::Watch.any_instance.stubs(:run!)
    Adva::Static::Rack::Watch.new(Adva::Static::Rack::Export.new(Rails.application, :target => export_dir), :dir => import_dir)
  end
end

When /^I touch the file "([^"]*)"$/ do |filename|
  file = import_dir.join(filename)
  file.utime(file.atime, future)
end

When /^the watcher triggers$/ do
  @watch.send(:handler).trigger
end

When /^I run the import task$/ do
  Adva::Static::Import.new(:source => import_dir).run
end

Then /^the watcher should "([^\"]*)" the following "([^\"]*)" params for the file "([^\"]*)":$/ do |method, key, file, table|
  import  = Adva::Static::Import.new(:source => import_dir)
  request = import.request_for(file)
  params  = request.params

# model = import.send(:recognize, file).first
# debugger

  case method.downcase!
  when 'put'
    assert_equal 'put', params['_method'].try(:downcase)
    assert_not_nil params[key.to_sym][:id], "expected params[:#{key}] to be not nil"
  when 'post'
    assert !params.key?('_method')
  end

  expected = table.rows_hash.symbolize_keys
  actual   = request.params[key.to_sym].except(:id).slice(*expected.keys)
  assert_equal expected, actual
end

Then /^there should be an export file "([^"]*)" containing "([^"]*)"$/ do |filename, text|
  file = export_dir.join(filename)
  assert file.exist?, "expected #{file.to_s.inspect} to exist"
  file = File.read(file)
  assert file.include?(text), "expected #{file.inspect} to include #{text.inspect} "
end
