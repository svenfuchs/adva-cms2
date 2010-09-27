Given /^an empty import directory "([^\"]*)"$/ do |name|
  @root = Pathname.new("/tmp/adva-static-test/import/#{name}")
  root.mkpath
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

When /^I run the import task$/ do
  Adva::Static::Import.new(:source => root).run
end

Then /^the watcher should "([^\"]*)" the following "([^\"]*)" params for the file "([^\"]*)":$/ do |method, key, file, table|
  import  = Adva::Static::Import.new(:source => root)
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
