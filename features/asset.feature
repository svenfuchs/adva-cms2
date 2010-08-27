@assets
Feature: Asset Management
  As a superuser
  I want to manage assets
  In order to manage all assets

  Background:
    Given the following products:
      | name   | number | price |
      | Kamera | 11111  | 90000 |
      | Tasche | 22222  | 15000 |
      | Objektiv | 33333  | 10000 |
    Given I am signed in
    And I am on the admin dashboard page

  Scenario: I want to see all assets on the assets page
    Given the following images:
      | title      | description           |
      | Rails Logo | This is a Rails Logo. |
    When I follow "Dateien"
    Then I should see a table "assets" with the following entries:
      | Title      | Description           |
      | Rails Logo | This is a Rails Logo. |

  Scenario: Create a new Asset with uploading a picture file
    When I follow "Dateien"
    Then I should see the "Assets" page
    Then I should see "No assets given."
    When I follow "New Asset"
    Then I should see "New asset"
    When I fill in "Title" with "Image1"
    And I fill in "Description" with "Image 1 description"
    And I fill in "asset_file" with "rails.png"
    Then show me the page
    And I press "Create Asset"

    


#
#  Scenario: I want to create a new bundle with a main product and add other products to my bundle
#    When I follow "Bundles"
#    Then I should see "There are no bundles yet"
#    When I follow "New"
#    Then I should see "Create new bundled product"
#    And I press "Create bundled product"
#    Then I should see "Create new bundled product"
#    And I should see "Could not find product with number "
#    When I fill in "Main product" with "11111"
#    And I press "Create bundled product"
#    Then I should see "can't be blank"
#    When I fill in "Name" with "Kamera mit Tasche"
#    And I fill in "Description" with "A very long description"
#    And I press "Create bundled product"
#    Then I should see "must be greater than 0"
#    And I fill in "Price" with "1025"
#    And I press "Create bundled product"
#    Then I should see "Edit bundled product"
#    And I should see "Bundled product was created successfully"
#    And I should see a "bundle_product_assignments" table with the following entries:
#      | Article no | Name   | Price | Quantity |
#      | 11111      | Kamera | 900   | 1        |
#    When I fill in "Product number" with "22222"
#    And I fill in "Quantity" with "2"
#    And I press "Add product"
#    Then I should see a "bundle_product_assignments" table with the following entries:
#      | Article no | Name   | Price | Quantity |
#      | 11111      | Kamera | 900   | 1        |
#      | 22222      | Tasche | 150   | 2        |
#    # check if product with number exists
#    When I fill in "Product number" with "does not exist"
#    And I fill in "Quantity" with "2"
#    And I press "Add product"
#    Then I should see "Could not find product with number "
#    And I should see a "bundle_product_assignments" table with the following entries:
#      | Article no | Name   | Price | Quantity |
#      | 11111      | Kamera | 900   | 1        |
#      | 22222      | Tasche | 150   | 2        |
#    Then the "Product number" field should contain ""
#    And the "Quantity" field should contain "2"
#    # check if quantity is entered
#    When I fill in "Product number" with "33333"
#    And I fill in "Quantity" with ""
#    And I press "Add product"
#    Then I should see "is not a number"
#    And I should see a "bundle_product_assignments" table with the following entries:
#      | Article no | Name     | Price | Quantity |
#      | 11111      | Kamera   | 900   | 1        |
#      | 22222      | Tasche   | 150   | 2        |
#    Then the "Product number" field should contain "33333"
#    # does not work ?? And the "Quantity" field should contain ""
#    # check if quantity is a number
#    And I fill in "Quantity" with "a"
#    And I press "Add product"
#    Then I should see "is not a number"
#    And I should see a "bundle_product_assignments" table with the following entries:
#      | Article no | Name   | Price | Quantity |
#      | 11111      | Kamera | 900   | 1        |
#      | 22222      | Tasche | 150   | 2        |
#    Then the "Product number" field should contain "33333"
#    And the "Quantity" field should contain ""
#    # check if quantity is a valid number
#    And I fill in "Quantity" with "0"
#    And I press "Add product"
#    Then I should see "must be greater than 0"
#    And I should see a "bundle_product_assignments" table with the following entries:
#      | Article no | Name   | Price | Quantity |
#      | 11111      | Kamera | 900   | 1        |
#      | 22222      | Tasche | 150   | 2        |
#    # update quantity if product already exists for bundle
#    And I fill in "Product number" with "22222"
#    And I fill in "Quantity" with "3"
#    And I press "Add product"
#    And I should see a "bundle_product_assignments" table with the following entries:
#      | Article no | Name   | Price | Quantity |
#      | 11111      | Kamera | 900   | 1        |
#      | 22222      | Tasche | 150   | 5        |
#    # update quantity if product already exists for bundle and quantity is invalid
#    And I fill in "Product number" with "22222"
#    And I fill in "Quantity" with "a"
#    And I press "Add product"
#    And I should see a "bundle_product_assignments" table with the following entries:
#      | Article no | Name   | Price | Quantity |
#      | 11111      | Kamera | 900   | 1        |
#      | 22222      | Tasche | 150   | 5        |
#
#  Scenario: I want to delete products of my bundle
#    Given the following bundles:
#      | name                    | number  | price  | main_product_number |
#      | Mein tolles Osterbundle | 11111-1 | 102500 | 11111               |
#    And the bundle "Mein tolles Osterbundle" has the following products:
#      | product_name | quantity |
#      | Kamera       | 1        |
#      | Tasche       | 2        |
#    When I follow "Bundles"
#    Then I should see a "bundles" table with the following entries:
#      | Name                    | Article no | Article count | Price |
#      | Mein tolles Osterbundle | 11111-1    | 3             | 1025  |
#    When I click on the edit link for bundle "Mein tolles Osterbundle"
#    Then I should see a "bundle_product_assignments" table with the following entries:
#      | Article no | Name   | Price | Quantity |
#      | 11111      | Kamera | 900   | 1        |
#      | 22222      | Tasche | 150   | 2        |
#    When I click on the delete button for product with number "11111"
#    Then I should see "You cannot delete the main product of a bundle, please select another main product first"
#    Then I should see a "bundle_product_assignments" table with the following entries:
#      | Article no | Name   | Price | Quantity |
#      | 11111      | Kamera | 900   | 1        |
#      | 22222      | Tasche | 150   | 2        |
#    When I click on the delete button for product with number "22222"
#    Then I should see "Product was deleted successfully from bundle"
#    And I should see a "bundle_product_assignments" table with the following entries:
#      | Article no | Name   | Price | Quantity |
#      | 11111      | Kamera | 900   | 1        |
#    When I follow "Bundles"
#    Then I should see a "bundles" table with the following entries:
#      | Name                    | Article no | Article count | Price |
#      | Mein tolles Osterbundle | 11111-1    | 1             | 1025  |
#
#  Scenario: I want to make a product of my bundle to be a main product
#    Given the following bundles:
#      | name                    | number  | price  | main_product_number |
#      | Mein tolles Osterbundle | 11111-1 | 102500 | 11111               |
#    And the bundle "Mein tolles Osterbundle" has the following products:
#      | product_name | quantity |
#      | Kamera       | 1        |
#      | Tasche       | 2        |
#    When I follow "Bundles"
#    And I click on the edit link for bundle "Mein tolles Osterbundle"
#    Then I should see that the product with the number "11111" is the main product
#    And I should see that the product with the number "22222" is not the main product
#    When I press "make_product_22222_main_product"
#    Then I should see that the product with the number "22222" is the main product
#    And I should see that the product with the number "11111" is not the main product

  # Scenario: I want to create a new bundle
  #   Given I am signed in
  #   And I am on the admin dashboard page
  #   When I follow "Bundles"
  #   Then I should see "Es gibt zur Zeit noch keine Bundles"
  #   When I press "Neues Bundle anlegen"
  #   Then I should see "Bitte fügen Sie Ihr Hauptprodukt hinzu"
  #   When I fill in "Produkt" with "Kamera mit Tasche"
  #   And I fill in "Preis" with "999,99 €"
  #   And I fill in "add_new_product" with "12345"
  #   And I press "Produkt hinzufügen"
  #   Then I should see "(Preis der Stückliste: 900,00€)"
  #   And I should see a table "product_items" with the following entries
# | Name   | Artikelnr. | Preis   | Kategorie | Anzahl |
# | Kamera | 12345      | 900,00€ | Foto      | 1      |
  #   When I fill in "add_new_product" with "23456"
  #   And I press "Produkt hinzufügen"
  #   Then I should see "(Preis der Stückliste: 900,00€)"
  #   And I should see a table "product_items" with the following entries
# | Name   | Artikelnr. | Preis   | Kategorie | Anzahl |
# | Kamera | 12345      | 900,00€ | Foto      | 1      |
# | Tasche | 23456      | 150,00€ | Foto      | 1      |


