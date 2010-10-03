require File.expand_path('../test_helper', __FILE__)

class AssetUploaderTest < Test::Unit::TestCase

  test "assets are stored in the expected directory if Rails.env is not test and when Rails.root is not nil" do
    Rails.env.stubs(:test?).returns(false)
    asset_mock = mock('Asset', :site_id => 1, :id => 2)
    uploader= AssetUploader.new
    uploader.stubs(:model).returns(asset_mock)
    # carrierwave prepends the public folder to the store_dir if Rails.root is present
    assert_equal "sites/site-1/assets/file/2", uploader.store_dir
  end

  test "assets are stored in a path under /tmp if Rails.env is test" do
    asset_mock = mock('Asset', :site_id => 1, :id => 2)
    uploader= AssetUploader.new
    uploader.stubs(:model).returns(asset_mock)
    assert_equal "/tmp/sites/site-1/assets/file/2", uploader.store_dir
  end

end