require File.expand_path('../../test_helper', __FILE__)

require 'asset'

# assert a user has many assets, this could be moved to a test-model
User.class_eval do
  has_many :assets, :as => :attachable
end

module AdvaAssets
  class AssetTest < Test::Unit::TestCase

    def setup
      super
      @site = Site.new(:account => Account.create!,
                       :name => 'TestSite', :title => 'Home', :host => "www.siewert-kau.de")
      @section = Section.new(:title => "Section1", :type => 'Page')
      @site.sections << @section
      @site.save!

      @asset_path = File.expand_path("../../fixtures/rails.png", __FILE__)
      @asset = Asset.create!(:file => File.open(@asset_path), :site => @site,
                             :title => "Rails Logo", :description => 'This is a Rails Logo.')
    end

    test "default asset meta data" do
      assert @asset.default_url == @asset.file.base_url + '/default.png'
    end

    test "new valid asset" do
      assert @asset.valid?
      assert File.exists?(@asset.path)
      assert File.exists?(@asset.current_path)
      assert @asset.file_url == @asset.base_url + "/rails.png"
      assert @asset.title == "Rails Logo"
      assert @asset.description == 'This is a Rails Logo.'
      assert @asset.basename == "rails"
      assert @asset.extname == "png"
      assert @asset.filename == "rails.png"
    end

    test "asset must have a file" do
      @invalid_asset = Asset.create(:site => @site, :title => "Rails Logo", :description => 'This is a Rails Logo.')
      assert !@invalid_asset.valid?
      assert_equal @invalid_asset.errors.first[1], "can't be blank"
    end

    test "asset must have a site assignment" do
      @invalid_asset = Asset.create(:file => File.open(@asset_path), :title => "Rails Logo", :description => 'This is a Rails Logo.')
      assert !@invalid_asset.valid?
      assert @invalid_asset.errors.first[1] == "can't be blank"
    end

    test "asset is assigned to a site" do
      assert @asset.site == @site
    end

    test "destroys the asset" do
      file = @asset.file
      assert File.exists?(file.path)
      @asset.destroy
      assert @asset.destroyed?
      assert !File.exists?(file.path)
    end

    test "have_permissions(0600)" do
      assert_equal File.stat(@asset.path).mode & 0777, 0600
    end

    test "objs can have different assigned assets" do
      @asset2 = Asset.create!(:file => File.open(@asset_path), :site => @site,
                              :title => "Rails Logo 2", :description => 'This is a Rails Logo 2.')
      user = User.create(:account_id => @site.account.id)
      user.assets << @asset
      user.assets << @asset2
      assert_equal user.assets.count, 2
      assert user.assets.include? @asset
      assert user.assets.include? @asset2
    end


    test "An asset belongs only to one object at a time" do
      user1 = User.create(:account_id => @site.account.id)
      user2 = User.create(:account_id => @site.account.id)
      user1.assets << @asset
      assert_equal @asset.attachable, user1
      user2.assets << @asset
      @asset.reload
      assert_equal @asset.attachable, user2
    end

  end
end
