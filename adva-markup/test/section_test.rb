require File.expand_path('../test_helper', __FILE__)

class AdvaMarkupSectionTest < Test::Unit::TestCase
  test "sections have a default_filter option" do
    section = Factory(:section)
    assert_nil section.default_filter

    section.update_attributes!(:default_filter => :textile)
    assert_equal 'textile', section.default_filter
  end
end

