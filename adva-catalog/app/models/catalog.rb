class Catalog < Section
  def products
    site.account.products
  end
end