@wip
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
  	When I fill in "Amount" with "2"
  	And I press "Add to shopping cart"
    Then I should see a product named "Apple Mac Mini"
  	And the sidebar cart box should contain the following products:
  		| name               | amount |
  		| Apple Mac Mini     | 2      |
	
  	When I go to the "Products" section
  	And I follow "Apple Macbook Pro"
    Then I should see a product named "Apple Macbook Pro"
  	And I press "Add to shopping cart"
    Then I should see a product named "Apple Macbook Pro"
  	And the sidebar cart box should contain the following products:
  		| name               | amount |
  		| Apple Mac Mini     | 2      |
  		| Apple Macbook Pro  | 1      |
	
  	When I follow "View cart"
  	Then I should be on the "Your shopping cart" page
  	And the cart should contain the following products:
  		| name               | amount |
  		| Apple Mac Mini     | 2      |
  		| Apple Macbook Pro  | 1      |
  	And I press "Delete" for the product "Apple Macbook Pro"
  	Then I should be on the "Your shopping cart" page
  	Then the cart should contain the following products:
  		| name               | amount |
  		| Apple Mac Mini     | 2      |
