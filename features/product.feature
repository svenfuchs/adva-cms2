Feature: Managing products
  As a superuser
  I want to manage products
  In order to add many images to products

  Background:
    Given the following products:
      | name   | number | price |
      | Kamera | 11111  | 90000 |
      | Tasche | 22222  | 15000 |
      | Objektiv | 33333  | 10000 |
    Given I am signed in
    And I am on the admin dashboard page

    When I follow "New section"
    Then I should see a section type form
    And the "Page" radio button should be checked
    And the "Catalog" radio button should not be checked
    And I should see a new page form
    When I choose "Catalog"
    And I press "Select"
    Then I should see a section type form
    And the "Page" radio button should not be checked
    And the "Catalog" radio button should be checked
    And I should see a new catalog form
    When I fill in "Title" with "Brand new catalog"
    And I press "Create catalog"
    Then I should be on the admin products list page of the "Brand new catalog" catalog

  Scenario: Creating a new product with an image
    When I follow "New Product"
    Then I should see a product form
    When I fill in "Name" with "Brand new product"
    And I fill in "Description" with "Brand new product's body"
    And I fill in "product_assets_attributes_0_file" with "rails.png"
    And I fill in "Title" with "Rails Logo"
    And I press "Create Product"
    Then I should see a product form
    And the "Name" field should contain "Brand new product"
    And the "Description" field should contain "Brand new product's body"
    When I fill in "Name" with "Updated product"
    And I fill in "Description" with "Updated product's body"
    And I fill in "product_assets_attributes_0_file" with "rails.png"
    And I fill in "Title" with "Rails Logo 2"
    And I press "Update Product"
    Then I should see a product form
    And the "Name" field should contain "Updated product"
    And the "Description" field should contain "Updated product's body"