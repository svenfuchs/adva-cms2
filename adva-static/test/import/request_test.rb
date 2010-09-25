require File.expand_path('../test_helper', __FILE__)

module AdvaStatic
  class ImportRequestTest < Test::Unit::TestCase
    include Adva::Static::Import::Model, TestHelper::Static

    test "returns request parameters necessary to create a new Page (w/ an index page)" do
      expected = { :page => { :site_id => '', :type => 'Page', :name => 'Home', :slug => 'home', :path => 'home',
        :article_attributes => { :body => '', :title => 'Home'} } }
      assert_equal expected, request('index.yml').params
    end

    test "returns request parameters necessary to create a new Page (w/ a non-index page)" do
      expected = { :page => { :site_id => '', :type => 'Page', :name => 'Contact', :slug => 'contact', :path => 'contact',
        :article_attributes => { :body => '', :title => 'Contact' } } }
      assert_equal expected, request('contact.yml').params
    end

    test "returns request parameters necessary to update an existing Page (w/ an index page)" do
      setup_root_page_record
      site = ::Site.first
      page = ::Page.find_by_path('home')
      article = page.article

      expected = { '_method' => 'put', :page => { :id => page.id.to_s, :site_id => site.id.to_s, :type => 'Page', :name => 'Home', 
        :slug => 'home', :path => 'home', :article_attributes => { :id => article.id.to_s, :body => '', :title => 'Home'} } }
      assert_equal expected, request('index.yml').params
    end

    test "returns request parameters necessary to update an existing Page (w/ a non-index page)" do
      setup_non_root_page_record
      site = ::Site.first
      page = ::Page.find_by_path('contact')
      article = page.article
    
      expected = { '_method' => 'put', :page => { :id => page.id.to_s, :site_id => site.id.to_s, :type => 'Page', :name => 'Contact', 
        :slug => 'contact', :path => 'contact', :article_attributes => { :id => article.id.to_s, :body => '', :title => 'Contact'} } }
      assert_equal expected, request('contact.yml').params
    end
  end
end