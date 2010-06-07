Feature: Managing sections
  Scenario: Creating a new page
    Given I am on the admin dashboard page
    When I follow "New section"
    Then I should see a new section form
    And I fill in "Title" with "Brand new section"
    And I select "Page" from "Type"
    And I press "Create"
    Then I should see an edit article form
    When I fill in "body" with "the brand new section's body"
    When I press "save"
    Then I should see an edit article form
    When I go to the admin site sections page
    Then I should see "Brand new section"
    When I follow "Brand new section"
    Then I should see an edit article form
    When I press "Delete"    
    Then I should be on the admin site sections page
    And I should see "Sections"
    And I should not see "Brand new section"