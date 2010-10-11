require File.expand_path('../test_helper', __FILE__)

Asset.has_many_polymorphs :assetables, :through => :asset_assignments, :from => [:users, :posts]
Image.has_many_polymorphs :assetables, :through => :asset_assignments, :foreign_key => 'asset_id', :from => [:users, :posts]
Video.has_many_polymorphs :assetables, :through => :asset_assignments, :foreign_key => 'asset_id', :from => [:users, :posts]

module AdvaAssets
  class AssetTest < Test::Unit::TestCase
    attr_reader :site, :asset

    def setup
      super
      @site = Factory(:site)
      @asset = Factory(:asset, :site => @site)
    end

    test 'new valid asset' do
      assert asset.valid?
      assert File.exists?(asset.path)
      assert File.exists?(asset.current_path)
    end

    test 'asset must have a site assignment' do
      invalid_asset = Factory.build(:asset, :site => nil)
      assert !invalid_asset.valid?
      assert_equal "can't be blank", invalid_asset.errors.first[1]
    end

    test 'asset is assigned to a site' do
      assert_not_nil asset.site
    end

    test 'destroys the asset' do
      file = asset.file
      assert File.exists?(file.path)
      asset.destroy
      assert asset.destroyed?
      assert !File.exists?(file.path)
    end

    test 'have_permissions(0644)' do
      assert_equal File.stat(asset.path).mode & 0777, 0666
    end

    test 'Assetables have many assets and assets have many asset_assignments and assetables' do
      asset1 = Factory(:asset, :site => site)
      asset2 = Factory(:asset, :site => site)

      user = Factory(:user)
      user.assets << asset1
      user.assets << asset2

      assert_equal 2, user.assets.count

      assert_equal 1, asset1.asset_assignments.count
      assert_equal user, asset1.asset_assignments.first.assetable
      assert_equal asset1.asset_assignments.find_by_assetable_id_and_assetable_type(user.id, 'User'),
        user.asset_assignments.find_by_asset_id(asset1.id)

      post = Factory(:post)
      post.assets << asset1
      post.assets << asset2

      assert_equal 2, post.assets.count

      assert_equal 2, asset1.asset_assignments.count
      assert_equal post, asset1.asset_assignments.last.assetable
      assert_equal asset1.asset_assignments.find_by_assetable_id_and_assetable_type(post.id, 'Content'),
        post.asset_assignments.find_by_asset_id(asset1.id)

      assert_equal [user, post], asset1.assetables
    end

    test 'Assetables have many images and images have many asset_assignments and assetables' do
      image1 = Factory(:image, :site => site)
      image2 = Factory(:image, :site => site)

      user = Factory(:user)
      user.images << image1
      user.images << image2

      assert_equal 2, user.images.count

      assert_equal 1, image1.asset_assignments.count
      assert_equal user, image1.asset_assignments.first.assetable
      assert_equal image1.asset_assignments.find_by_assetable_id_and_assetable_type(user.id, 'User'),
        user.asset_assignments.find_by_asset_id(image1.id)

      post = Factory(:post)
      post.images << image1
      post.images << image2

      assert_equal 2, post.images.count

      assert_equal 2, image1.asset_assignments.count
      assert_equal post, image1.asset_assignments.last.assetable
      assert_equal image1.asset_assignments.find_by_assetable_id_and_assetable_type(post.id, 'Content'),
        post.asset_assignments.find_by_asset_id(image1.id)

      assert_equal [user, post], image1.assetables
    end

    test 'Assetables have many videos and videos have many asset_assignments and assetables' do
      video1 = Factory(:video, :site => site)
      video2 = Factory(:video, :site => site)

      user = Factory(:user)
      user.videos << video1
      user.videos << video2

      assert_equal 2, user.videos.count

      assert_equal 1, video1.asset_assignments.count
      assert_equal user, video1.asset_assignments.first.assetable
      assert_equal video1.asset_assignments.find_by_assetable_id_and_assetable_type(user.id, 'User'),
        user.asset_assignments.find_by_asset_id(video1.id)

      post = Factory(:post)
      post.videos << video1
      post.videos << video2

      assert_equal 2, post.videos.count

      assert_equal 2, video1.asset_assignments.count
      assert_equal post, video1.asset_assignments.last.assetable
      assert_equal video1.asset_assignments.find_by_assetable_id_and_assetable_type(post.id, 'Content'),
        post.asset_assignments.find_by_asset_id(video1.id)

      assert_equal [user, post], video1.assetables
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

    test "images and videos are assets" do
      video = Factory(:video, :site => site)
      image = Factory(:image, :site => site)
      asset = Factory(:asset, :site => site)

      assert 1, Image.count
      assert 1, Video.count
      assert 3, Asset.count
    end

  end
end
