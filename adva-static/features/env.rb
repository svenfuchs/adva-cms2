require File.expand_path('../../../adva-core/features/env', __FILE__)

require Adva::Static.root.join('lib/testing/test_helper')
World(TestHelper::Static)

After do
  teardown_import_directory
end