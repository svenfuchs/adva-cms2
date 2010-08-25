Feature: Asset Management
  Background:

  Scenario: Create a new Asset with uploading a picture file
    Given I am signed in with "admin@admin.org" and "admin"
    Given I am on the admin dashboard page
    When I follow "Dateien"
    #Then show me the page
    Then I output the page