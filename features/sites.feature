Feature: Managing sites
  Scenario: Creating a new site
    Given I am signed in
    And I am on the admin dashboard page
    When I follow "New site"
    Then I should see a new site form
    And I fill in "Name" with "Site 2"
    And I fill in "Title" with "Brand new site"
    And I fill in "Host" with "localhost:3000"
    And I select "Page" from "Type"
    And I fill in "Section title" with "Welcome to this Site"
    And I press "Create"
    Then I should be on the admin dashboard page for the site on "localhost:3000"
    When I go to the admin sites page
    Then I should see "Site 2"
    When I follow "Site 2"
    Then I should see "All Sections"
    When I follow "All Sections"
    Then I should see "Welcome to this Site"
