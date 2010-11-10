require File.expand_path('../test_helper', __FILE__)

module AdvaCoreTests
  class PageTest < Test::Unit::TestCase
    attr_reader :site

    def setup
      @site = Site.create!(
        :host => 'localhost:3000',
        :title => 'Site Title',
        :name => 'Site Name',
        :sections_attributes => [{ :name => 'Home' }]
      )
    end

    test "page accepts article body and title attributes" do
      page = Page.create!(
        :name => 'Page',
        :site_id => site.id,
        :title => 'Title',
        :body => 'Body'
      )
      assert !page.article.new_record?
      assert_equal 'Title', page.article.title
      assert_equal 'Body', page.article.body
    end

    test "a new page has a default article set" do
      assert Page.new(:site => site).article.is_a?(Article)
    end
  end
end
