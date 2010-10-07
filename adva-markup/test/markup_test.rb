require File.expand_path('../test_helper', __FILE__)

class AdvaMarkupTest < Test::Unit::TestCase
  test "filters" do
    expected = { :markdown => 'RDiscount', :textile => 'RedCloth' }
    assert_equal expected, Adva::Markup.filters
  end

  test "options" do
    expected = { 'markdown' => 'Markdown', 'textile' => 'Textile' }
    assert_equal expected, Adva::Markup.options
  end

  test "filter(:markdown)" do
    assert_equal RDiscount, Adva::Markup.filter(:markdown)
  end

  test "filter(:textile)" do
    assert_equal RedCloth, Adva::Markup.filter(:textile)
  end

  test "apply(:markdown, markup)" do
    assert_equal "<p><strong>foo</strong></p>\n", Adva::Markup.apply(:markdown, '**foo**')
  end

  test "apply(:textile, markup)" do
    assert_equal '<p><b>foo</b></p>', Adva::Markup.apply(:textile, '**foo**')
  end

  test "content applies filter before save" do
    content = Content.create(:body => '**foo**', :filter => 'textile')
    assert_equal '<p><b>foo</b></p>', content.body_html
  end
end
