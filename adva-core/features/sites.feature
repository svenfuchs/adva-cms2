Feature: Managing sites

  Background:
    Given a site
    And I am signed in with "admin@admin.org" and "admin!"

  Scenario: Listing sites
    Given I am on the admin sites page
    Then I should see a list of sites
    And I should see "adva-cms"

  Scenario: Creating a new site
    Given I am on the admin dashboard page

    When I follow "New Site"
    Then I should see a new site form
    When I fill in the following:
      | Name  | a site name    |
      | Title | brand new site |
      | Host  | localhost:3000 |
     And I choose "Page"
     And I fill in "Section Name" with "Welcome to this Site"
     And I press "Create"
    Then I should be on the admin dashboard page for the site on "localhost:3000"

    When I follow "Settings" in the top menu
    Then I should see an edit site form
    When I fill in "Name" with "An updated site"
     And I press "Update"
    Then I should see an edit site form

    When I go to the admin sites page
    Then I should see a link "An updated site"
    When I follow that link
     And I follow "Sections"
    Then I should see "Welcome to this Site"
