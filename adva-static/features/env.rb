require File.expand_path('../../../adva-core/lib/testing/env', __FILE__)

require Adva::Static.root.join('lib/testing/test_helper')
World(TestHelper::Static)

After do
  teardown_import_directory
  teardown_export_directory
end
