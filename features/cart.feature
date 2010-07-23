Feature: Using the cart
  Background:
    Given a catalog titled "Products"
    And the following products:
      | name              | price  |
      | Apple Mac Mini    | 60000  |
      | Apple Macbook Pro | 110000 |

  Scenario: Adding products to the cart and updating the cart
    Given I am on the "Products" section page
    And I follow "Apple Mac Mini"
    Then I should see a product named "Apple Mac Mini"
  	When I fill in "Quantity" with "2"
  	And I press "Add to cart"
    Then I should see a product named "Apple Mac Mini"
  	And the current user's cart should contain the following items:
  		| product            | quantity |
  		| Apple Mac Mini     | 2      |

  	When I go to the "Products" section page
  	And I follow "Apple Macbook Pro"
    Then I should see a product named "Apple Macbook Pro"
    When I press "Add to cart"
    Then I should see a product named "Apple Macbook Pro"
  	And the current user's cart should contain the following items:
  		| product            | quantity |
  		| Apple Mac Mini     | 2      |
  		| Apple Macbook Pro  | 1      |

  	When I go to the cart page
  	Then the cart should contain the following items:
  		| product            | quantity |
  		| Apple Mac Mini     | 2      |
  		| Apple Macbook Pro  | 1      |
  	When I press "Delete" for the item "Apple Macbook Pro"
  	Then I should be on the cart page
  	And the cart should contain the following items:
  		| product            | quantity |
  		| Apple Mac Mini     | 2      |

  	When I follow "Checkout"
  	Then I should be on the enter new shipping address page
  	When I fill in "Name" with "John Doe"
     And I fill in "Street" with "Sesamestreet 1"
     And I fill in "Zipcode" with "12345"
     And I fill in "City" with "Philadelphia"
     And I fill in "Country" with "USA"
         And I press "Save"
    
    # Then the cart should have the following shipping address:
    #   | name     | street         | zipcode | city         | country |
    #   | John Doe | Sesamestreet 1 | 12345   | Philadelphia | USA     |
    # And I should see a select payment method form

