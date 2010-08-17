# require File.expand_path('../test_helper', __FILE__)
#
# module AdvaCoreTests
#   class PageTest < Test::Unit::TestCase
#     attr_reader :page_params
#
#     def setup
#       @site = Site.create(
#         :host => 'localhost:3000',
#         :title => 'Site Title',
#         :name => 'Site Name',
#         :sections_attributes => [{ :title => 'Home' }]
#       )
#       @page_params = {
#         :title => 'Page title',
#         :site_id => @site.id,
#         :article_attributes => { :title => 'Article Title', :body => 'Body' }
#       }
#     end
#
#     test "page accepts nested attributes for article" do
#       page = Page.create(page_params)
#       assert !page.article.new_record?
#       assert_equal 'Body', page.article.body
#     end
#
#   end
# end