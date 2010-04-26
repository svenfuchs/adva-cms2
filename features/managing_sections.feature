Feature: Managing Sections
  Scenario: Creating a new page
    Given I am on the admin dashboard page
    When I follow "New section"
    Then I should see a new section form
    And I fill in "Title" with "Brand new section"
    And I select "Page" from "Type"
    And I press "Create"
    # Then I should see an edit article form
    Then I should see an edit section form
    # When I fill in "body" with "the brand new section's body"
    When I press "save"
    Then I should see an edit section form
    # And I follow "preview"
    # Then I should see be on the "brand new section" page
    When I press "delete"
    Then I should be on the admin sections index page