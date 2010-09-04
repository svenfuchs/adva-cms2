require File.expand_path('../../../adva-core/test/test_helper', __FILE__)

$: << File.expand_path('../../../adva-cnet/lib', __FILE__)

require 'adva/cnet/downloader'
require 'adva/cnet/origin'
require 'adva/tasks/cnet'

# require File.expand_path('../test_helper/setup_database', __FILE__)

fixtures_path = File.expand_path('/tmp/adva-cnet-test/fixtures', __FILE__)
unless File.directory?("#{fixtures_path}/catalog")
  FileUtils.mkdir_p(fixtures_path)
  `unzip #{File.expand_path('../fixtures/download.zip', __FILE__)} -d #{fixtures_path}`
end
CNET_FIXTURES_PATH = fixtures_path
