require File.expand_path('../../test_helper', __FILE__)

require 'asset'

module AdvaAssets
  class AssetTest < Test::Unit::TestCase

    def setup
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
      assert_equal (File.stat(@asset.path).mode & 0777), 0600
    end

    test "objs can have different assigned assets" do
      @asset2 = Asset.create!(:file => File.open(@asset_path), :site => @site,
                              :title => "Rails Logo 2", :description => 'This is a Rails Logo 2.')
      product1 = Product.create(:account => @site.account, :number => '12345', :name => "Kaffeetasse", :description => "Kaffeetasse mit Unterteller")
      AssetAssignment.create!(:product => product1, :asset => @asset, :weight => 1000)
      AssetAssignment.create!(:product => product1, :asset => @asset2, :weight => 1100)
      assert_equal Product.first.assets.count, 2
      assert Product.first.assets.include? @asset
      assert Product.first.assets.include? @asset2
    end

    test "is assigend to many products" do
      product1 = Product.create(:account => @site.account, :number => '12345', :name => "Kaffeetasse", :description => "Kaffeetasse mit Unterteller")
      AssetAssignment.create!(:product => product1, :asset => @asset, :weight => 1000)
      assert_equal Asset.first.objs.count, 1
      assert_equal Asset.first.objs.first, product1
      product2 = Product.create(:account => @site.account, :number => '23456', :name => "Teekanne", :description => "Blaue Tekanne")
      AssetAssignment.create!(:product => product2, :asset => @asset, :weight => 1100)
      assert_equal Asset.first.objs.count, 2
      assert_equal Asset.first.objs.last, product2
    end

    test "assign an asset to a product only one time" do
      product1 = Product.create(:account => @site.account, :number => '12345', :name => "Kaffeetasse", :description => "Kaffeetasse mit Unterteller")
      AssetAssignment.create!(:product => product1, :asset => @asset, :weight => 1000)
      assert_equal Asset.first.objs.count, 1
      assert_equal Asset.first.objs.first, product1
      assert_raises ActiveRecord::RecordInvalid do
        AssetAssignment.create!(:product => product1, :asset => @asset, :weight => 1100)
      end
    end

  end
end
