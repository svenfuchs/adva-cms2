require File.expand_path('../../test_helper', __FILE__)

class ProductTest < Test::Unit::TestCase
  
  def setup
    @account = Account.create
  end
  
  test "Products should belong to account" do
    assert @account.products.empty?
    product = @account.products.create
    assert_equal @account, product.account
  end

end