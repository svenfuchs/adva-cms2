Feature: Managing sections
  Scenario: Creating a new page
    Given I am signed in
    Given I am on the admin dashboard page

    When I follow "New section"
    Then I should see a new section form
    When I fill in "Title" with "Brand new section"
    When I fill in "Heading" with "The brand new section's heading"
    And I fill in "Body" with "The brand new section's body"
    And I select "Page" from "Type"
    And I press "Create"
    Then I should see an edit section form
    
    When I fill in "Body" with "The updated brand new section's body"
    When I press "save"
    Then I should see an edit section form
    
    When I follow "Website"
    Then I should see a page titled "Brand new section"
    And I should see "The updated brand new section's body"
    
    When I go to the admin site sections page
    Then I should see "Brand new section"
    When I follow "Brand new section"
    When I press "Delete"    
    Then I should be on the admin site sections page
    And I should see "Sections"
    And I should not see "Brand new section"
    