require File.expand_path('../../test_helper', __FILE__)

require 'adva/asset'
require 'adva/image'

require 'carrierwave/test/matchers'

module AdvaAssets
  class AssetTest < Test::Unit::TestCase

    def setup
      @site = Site.new(:account => Account.create!,
                       :name => 'TestSite', :title => 'Home', :host => "www.siewert-kau.de")
      @section = Section.new(:title => "Section1", :type => 'Page')
      @site.sections << @section
      @site.save!

      @image_path = File.expand_path("../../fixtures/rails.png", __FILE__)
      @image = Adva::Image.create!(:file => File.open(@image_path), :site => @site,
                                   :title => "Rails Logo", :description => 'This is a Rails Logo.')
    end

    test "creates a valid image" do
      assert @image.valid?
      @txt_path = File.expand_path("../../fixtures/test.txt", __FILE__)
      assert File.exists?(@txt_path)
      @txt = Adva::Image.create(:file => File.open(@txt_path), :site => @site,
                                   :title => "Rails Logo", :description => 'This is a Rails Logo.')
      assert !@txt.valid?
      assert_equal @txt.errors.first[1], "is not an allowed type of file."
    end

    test "adds a invalid image file" do
      @txt_path = File.expand_path("../../fixtures/test.jpg", __FILE__)
      assert File.exists?(@txt_path)
      assert_raises MiniMagick::Error do
        @txt = Adva::Image.create(:file => File.open(@txt_path), :site => @site,
                                   :title => "Rails Logo", :description => 'This is a Rails Logo.')
      end
    end

    test "processed size of image" do
      image = CarrierWave::Test::Matchers::ImageLoader.load_image(@image.path)
      assert_equal 470, image.width
      assert_equal 600, image.height
    end

    test "processed size of thumb" do
      image = CarrierWave::Test::Matchers::ImageLoader.load_image(@image.thumb.path)
      assert_equal image.width, 64
      assert_equal image.height, 64
    end

    test "processed size of small image" do
      image = CarrierWave::Test::Matchers::ImageLoader.load_image(@image.small.path)
      assert_equal image.width, 200
      assert_equal image.height, 200
    end

    test "doesn't stretch medium image to default image size" do
      @medium_image_path = File.expand_path("../../fixtures/rails_medium.png", __FILE__)
      @medium_image = Adva::Image.create!(:file => File.open(@medium_image_path), :site => @site,
                                   :title => "Rails Logo", :description => 'This is a Rails Logo.')

      image = CarrierWave::Test::Matchers::ImageLoader.load_image(@medium_image.path)
      assert_equal 446, image.width
      assert_equal 316, image.height
    end

  end
end
