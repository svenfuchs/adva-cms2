require File.expand_path('../test_helper', __FILE__)

class AdvaMarkupModelTest < Test::Unit::TestCase
  test "returns the unfiltered attribute value if filter_attributes is false" do
    Model.read_filtered_attributes = false
    assert_equal 'unfiltered', Model.new(:body => 'unfiltered', :body_html => 'filtered').body
  end

  test "returns the filtered attribute value if filter_attributes is true" do
    Model.read_filtered_attributes = true
    assert_equal 'filtered', Model.new(:body => 'unfiltered', :body_html => 'filtered').body
  end

  class Model < ActiveRecord::Base
    set_table_name 'adva_markup_test_models'
    filters :body
  end

  ActiveRecord::Schema.define(:version => 1) do
    create_table "adva_markup_test_models", :force => true do |t|
      t.string :body
      t.string :body_html
    end
  end unless Model.table_exists?
end



