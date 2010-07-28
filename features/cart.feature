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
  	When I fill in the following:
  	  | Email   | john@doe.com   |
  	  | Name    | John Doe       |
  	  | Street  | Sesamestreet 1 |
  	  | Zipcode | 12345          |
  	  | City    | Philadelphia   |
  	  | Country | USA            |
     And I select "UPS Priority" from "Delivery method"
     And I press "Continue"
    
    Then the cart should have the email address "john@doe.com"
    And the cart should have the delivery method "UPS Priority"
    And the cart should have the following shipping address:
      | name     | street         | zipcode | city         | country |
      | John Doe | Sesamestreet 1 | 12345   | Philadelphia | USA     |
    And I should be on the select payment method page
    When I select "Prepaid" from "Payment method"
    And I press "Continue"
    
    Then the cart should have the payment method "Prepaid"
    And I should be on the order confirmation page

    When I press "Confirm"
    Then the following emails should have been sent:
      | to              | subject                 | body                                     |
      | john@doe.com    | Your order confirmation | Apple Mac Mini, 600.00 EUR, 1,200.00 EUR |
      | admin@admin.org | New order               | Apple Mac Mini, 600.00 EUR, 1,200.00 EUR |




