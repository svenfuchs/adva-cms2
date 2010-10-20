require File.expand_path('../test_helper', __FILE__)

class AdvaMarkupControllerTest < Test::Unit::TestCase
  class FooController < BaseController
    attr_reader :params

    def initialize(params)
      @params = params
    end

    include do
      def render(*)
        Content.filter_attributes
      end
    end
  end

  test "with :only => :show it sets Content.filtered_attributes to true while rendering :show" do
    FooController.filtered_attributes :content, :only => :show
    assert FooController.new(:action => 'show').render
  end

  test "with :only => :show it sets Content.filtered_attributes to false while rendering :index" do
    FooController.filtered_attributes :content, :only => :show
    assert !FooController.new(:action => 'index').render
  end

  test "with :except => :index it sets Content.filtered_attributes to true while rendering :show" do
    FooController.filtered_attributes :content, :except => :index
    assert FooController.new(:action => 'show').render
  end

  test "with :except => :index it sets Content.filtered_attributes to false while rendering :index" do
    FooController.filtered_attributes :content, :except => :index
    assert !FooController.new(:action => 'index').render
  end
end


