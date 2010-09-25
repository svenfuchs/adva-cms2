Given /^an empty import directory "([^\"]*)"$/ do |name|
  @root = Pathname.new("/tmp/adva-static-test/import/#{name}")
  root.mkpath
end

Given /^a source file "([^\"]*)" with the following values:$/ do |filename, hash|
  setup_files([filename, YAML.dump(hash.rows_hash)])
end

Given /^the following source files:$/ do |table|
  table.hashes.each do |hash|
    setup_files([hash.delete('file'), YAML.dump(hash)])
  end
end

When /^I run the import task$/ do
  Adva::Static::Import.new(:source => root).run
end