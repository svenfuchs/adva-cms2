require File.expand_path('../test_helper', __FILE__)

Asset.has_many_polymorphs :assetables, :through => :asset_assignments, :from => [:users, :posts]
Image.has_many_polymorphs :assetables, :through => :asset_assignments, :from => [:users, :posts]
Video.has_many_polymorphs :assetables, :through => :asset_assignments, :from => [:users, :posts]

module AdvaAssets
  class AssetTest < Test::Unit::TestCase
    attr_reader :site, :image, :video, :asset, :fixtures

    def setup
      super
      @site = Factory(:site)
      @fixtures = Pathname.new(File.expand_path('../fixtures', __FILE__))
      @image = fixtures.join('rails.png')
      @video = fixtures.join('sample_video.swf')
      @asset = create_asset
    end

    test 'new valid asset' do
      assert asset.valid?
      assert File.exists?(asset.path)
      assert File.exists?(asset.current_path)
      assert asset.title == 'title'
      assert asset.description == 'description'
      assert asset.filename == 'rails.png'
    end

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

      post = Factory(:post)
      post.assets << asset1
      post.assets << asset2

      assert_equal 2, post.assets.count
      assert [asset1, asset2], post.assets
    end

    test 'Assetables have many images' do
      image1 = create_image
      image2 = create_image

      user = Factory(:user)
      user.images << image1
      user.images << image2

      assert_equal 2, user.images.count
      assert [image1, image2], user.images

      post = Factory(:post)
      post.images << image1
      post.images << image2

      assert_equal 2, post.images.count
      assert [image1, image2], post.images
    end

    test 'Assetables have many videos' do
      video1 = create_video
      video2 = create_video

      user = Factory(:user)
      user.videos << video1
      user.videos << video2

      assert_equal 2, user.videos.count
      assert [video1, video2], user.videos

      post = Factory(:post)
      post.videos << video1
      post.videos << video2

      assert_equal 2, post.videos.count
      assert [video1, video2], post.videos
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
      video = create_video
      image = create_image
      asset = create_asset

      assert 1, Image.count
      assert 1, Video.count
      assert 3, Asset.count
    end

    def create_asset(options = {})
      Asset.create(options.reverse_merge(:file => File.open(image), :site => site, :title => 'title', :description => 'description'))
    end

    def create_image(options = {})
      Image.create(options.reverse_merge(:file => File.open(image), :site => site, :title => 'title', :description => 'description'))
    end

    def create_video(options = {})
      Video.create(options.reverse_merge(:file => File.open(video), :site => site, :title => 'title', :description => 'description'))
    end

  end
end
