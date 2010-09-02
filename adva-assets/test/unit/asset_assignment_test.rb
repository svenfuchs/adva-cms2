require File.expand_path('../../test_helper', __FILE__)

require 'asset'

module AdvaAssets
  class AssetAssignmentTest < Test::Unit::TestCase

    def setup
      @site = Site.new(:account => Account.create!,
                       :name => 'TestSite', :title => 'Home', :host => "www.siewert-kau.de")
      @section = Section.new(:title => "Section1", :type => 'Page')
      @site.sections << @section
      @site.save!

      @asset_path = File.expand_path("../../fixtures/rails.png", __FILE__)
      @asset1 = Asset.create!(:file => File.open(@asset_path), :site => @site,
                             :title => "Rails Logo", :description => 'This is a Rails Logo.')
      @asset2 = Asset.create!(:file => File.open(@asset_path), :site => @site,
                             :title => "Rails Logo", :description => 'This is a Rails Logo.')
      @product = Product.create(:account => @site.account, :number => '23456',
                                :name => "Teekanne", :description => "Blaue Tekanne")

    end

    test "unique weight of assigned assets for a product" do
      AssetAssignment.create!(:product => @product, :asset => @asset1, :weight => 1000)
      asset = AssetAssignment.create(:product => @product, :asset => @asset1, :weight => 1000)
      assert !asset.valid?
      #assert asset.errors[:base].first = ""
    end
  end
end
