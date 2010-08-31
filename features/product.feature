#Feature: Managing products
#  As a superuser
#  I want to manage products
#  In order to add many images to products
#
#  Background:
#    Given the following products:
#      | name   | number | price |
#      | Kamera | 11111  | 90000 |
#      | Tasche | 22222  | 15000 |
#      | Objektiv | 33333  | 10000 |
#    Given I am signed in
#    And I am on the admin dashboard page
#
#    When I follow "New section"
#    Then I should see a section type form
#     And the "Page" radio button should be checked
#     And the "Catalog" radio button should not be checked
#     And I should see a new page form
#
#    When I choose "Catalog"
#    And I press "Select"
#    Then I should see a section type form
#    And the "Page" radio button should not be checked
#    And the "Catalog" radio button should be checked
#    And I should see a new catalog form
#    When I fill in "Title" with "Brand new catalog"
#    And I press "Create catalog"
#    Then I should be on the admin products list page of the "Brand new catalog" catalog
#    But I should not see any products
#    When I follow "Settings"
#    Then I should see an edit catalog form
#    When I fill in "Title" with "Updated catalog"
#    When I press "Update catalog"
#    Then I should see an edit catalog form
#    When I follow "Website"
#    Then I should see a catalog
#    And I should not see any products
#    When I go to the admin site sections page
#    Then I should see "Updated catalog"
#    When I follow "Updated catalog"
#
#  Scenario: Creating a new product with an image
#     And I follow "New Product"
#    Then I should see a product form
#
#    When I fill in "Name" with "Brand new product"
#     And I fill in "Description" with "Brand new product's body"
#     And I press "Create Product"
#    Then I should see a product form
#
#    When I fill in "Name" with "Updated product"
#     And I fill in "Description" with "Updated product's body"
#     And I press "Update Product"
#    Then I should see a product form