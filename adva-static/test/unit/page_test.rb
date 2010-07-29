require File.expand_path('../../test_helper', __FILE__)

module AdvaStatic
  class PageTest < Test::Unit::TestCase
    attr_reader :page

    def setup
      @page = Adva::Static::Page.new '/foo/bar', <<-html
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
    end

    test "urls" do
      assert_equal %w(/foo.html /styles.css /script.js), page.urls
    end
  end
end