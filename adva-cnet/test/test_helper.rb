require File.expand_path('../../../adva-core/test/test_helper', __FILE__)

$: << File.expand_path('../../../adva-cnet/lib', __FILE__)

require 'adva-cnet'
require 'adva/tasks/cnet'

require File.expand_path('../test_helper/setup_database', __FILE__)

# fixtures_path = File.expand_path('/tmp/adva-cnet-test/fixtures', __FILE__)
# unless File.directory?("#{fixtures_path}/catalog")
#   FileUtils.mkdir_p(fixtures_path)
#   `unzip #{File.expand_path('../fixtures/download.zip', __FILE__)} -d #{fixtures_path}`
# end
# CNET_FIXTURES_PATH = fixtures_path

module CnetTestHelper
  attr_reader :origin, :import

  def setup
    @origin  = Adva::Cnet::Connections.origin
    @import  = Adva::Cnet::Connections.import
    super
  end

  def teardown
    origin.clear!
    import.clear!
    super
  end
        
  def create_product(number)
    Array(number).each { |number| Product.create!(:number => number) }
  end
  
  def create_cnet_category(ext_category_id)
    Array(ext_category_id).each { |ext_category_id| ::Cnet::Category.create!(:ext_category_id => ext_category_id) }
  end
  
  def create_cnet_manufacturer(ext_manufacturer_id)
    Array(ext_manufacturer_id).each { |ext_manufacturer_id| ::Cnet::Manufacturer.create!(:ext_manufacturer_id => ext_manufacturer_id) }
  end
end