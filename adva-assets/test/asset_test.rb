require File.expand_path('../test_helper', __FILE__)

Adva::Registry.set(:assetable_types, [:users, :posts])

require 'asset'
require 'post'

module AdvaAssets
  class AssetTest < Test::Unit::TestCase
    attr_reader :site, :image, :asset, :fixtures

    def setup
      super
      @site = Factory(:site)
      @fixtures = Pathname.new(File.expand_path('../fixtures', __FILE__))
      @image = fixtures.join('rails.png')
      @asset = create_asset
    end

    def create_asset(options = {})
      Asset.create(options.reverse_merge(:file => File.open(image), :site => site, :title => 'title', :description => 'description'))
    end

    test 'new valid asset' do
      assert asset.valid?
      assert File.exists?(asset.path)
      assert File.exists?(asset.current_path)
      assert asset.title == 'title'
      assert asset.description == 'description'
      assert asset.filename == 'rails.png'
    end

    # test 'asset must have a file' do
    #   invalid_asset = create_asset(:file => nil)
    #   assert !invalid_asset.valid?
    #   assert_equal "can't be blank", invalid_asset.errors.first[1]
    # end

    test 'asset must have a site assignment' do
      invalid_asset = create_asset(:site => nil)
      assert !invalid_asset.valid?
      assert_equal "can't be blank", invalid_asset.errors.first[1]
    end

    test 'asset is assigned to a site' do
      assert asset.site == site
    end

    test 'destroys the asset' do
      file = asset.file
      assert File.exists?(file.path)
      asset.destroy
      assert asset.destroyed?
      assert !File.exists?(file.path)
    end

    test 'have_permissions(0600)' do
      assert_equal File.stat(asset.path).mode & 0777, 0600
    end

    test 'Assetables have many assets' do
      asset1 = create_asset
      asset2 = create_asset

      user = Factory(:user)
      user.assets << asset1
      user.assets << asset2

      assert_equal 2, user.assets.count
      assert [asset1, asset2], user.assets
    end

    test 'An asset belongs to many polymorphic assetables' do
      user_1 = Factory(:user)
      user_2 = Factory(:user)
      post   = Factory(:post)

      user_1.assets << asset
      user_2.assets << asset
      post.assets  << asset
      [user_1, user_2, post, asset].map(&:reload)

      assert_equal [user_1, user_2, post], asset.assetables
      assert_equal [asset], user_1.assets
      assert_equal [asset], user_2.assets
      assert_equal [asset], post.assets
    end
  end
end
