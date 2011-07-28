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
      assert_equal %w(/foo.html /script.js /styles.css), page.urls.sort
    end
  end
end
