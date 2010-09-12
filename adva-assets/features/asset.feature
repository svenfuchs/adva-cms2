@assets
Feature: Asset Management
  As a superuser
  I want to manage assets
  In order to manage all assets

  Background:
    Given I am signed in with "admin@admin.org" and "admin"
    And I am on the admin dashboard page

  Scenario: I want to see all assets on the assets page
    Given the following images:
      | title      | description           |
      | Rails Logo | This is a Rails Logo. |
    When I follow "Assets"
    Then I should see a table "assets" with the following entries:
      | Title      | Description           |
      | Rails Logo | This is a Rails Logo. |

  Scenario: Create, update and delete a new Asset with uploading a picture file
    When I follow "Assets"
    Then I should see the "Assets" page
    Then I should see "No assets given."
    When I follow "New Asset"
    Then I should see "New asset"
    When I fill in "Title" with "Image1"
    And I fill in "Description" with "Image 1 description"
    And I fill in "asset_file" with "rails.png"
    And I press "Create Asset"
    Then I should see the "Assets" page
    And I should see a table "assets" with the following entries:
      | Title      | Description           |
      | Image1     | Image 1 description   |
    When I click "edit" in the row where "Title" is "Image1"
    Then I should see "Edit asset"
    And the "Title" field should contain "Image1"
    And the "Description" field should contain "Image 1 description"
    When I fill in "Title" with "Image2"
    And I fill in "Description" with "Image 2 description"
    And I press "Update Asset"
    Then I should see the "Assets" page
    And I should see a table "assets" with the following entries:
      | Title      | Description           |
      | Image2     | Image 2 description   |
    When I press "delete" in the row where "Title" is "Image2"
    Then I should see "No assets given."
