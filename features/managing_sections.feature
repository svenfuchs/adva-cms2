Feature: Managing Sections
  Scenario: Creating a new page
    Given I am on the admin dashboard page
    When I follow "New section"
    Then I should see a new adva_section form
    And I fill in "Title" with "Brand new section"
    And I select "Page" from "Type"
    And I press "Create"
    # Then I should see an edit adva_article form
    Then I should see an edit adva_section form
    # And I fill in "body" with "the brand new section's body"
    # And I press "save"
    # Then I should see an update article form
    # And I follow "preview"
    # Then I should see be on the "brand new section" page
