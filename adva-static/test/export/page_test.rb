require File.expand_path('../../test_helper', __FILE__)

module AdvaStatic
  class PageTest < Test::Unit::TestCase
    test "urls" do
      page = Adva::Static::Export::Page.new '/foo/bar', <<-html
        <html>
          <head>
            <script src="/script.js"/>
            <link rel="stylesheet" href="/styles.css"/>
          </head>
          <body>
            <a href="http://example.com/foo.html/?bar=baz">bar</a>
          </body>
        </html>
      html
      assert_equal %w(/foo.html /styles.css /script.js), page.urls
    end
    
    # test "can cope with weird/broken urls in the content" do
    #   page = Adva::Static::Page.new '/foo/bar', <<-html
    #     <a href="http://localhost:3000">http://localhost:3000</a>
    #     <a href="http://localhost:3xxx">http://localhost:3xxx</a>
    #   html
    #   assert_equal [], page.urls
    # end
  end
end