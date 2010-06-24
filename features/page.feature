Feature: Managing pages
  Scenario: Creating a new page
    Given I am signed in
    Given I am on the admin dashboard page

    When I follow "New section"
    Then I should see a section type form
     And the "Page" radio button should be checked
     And I should see a new page form
     
    When I fill in "Title" with "Brand new section"
     And I fill in "Heading" with "The brand new section's heading"
     And I fill in "Body" with "The brand new section's body"
     And I press "Create"
    Then I should see an edit page form
    
    When I fill in "Title" with "Updated section"
    When I fill in "Body" with "The updated section's body"
    When I press "Save"
    Then I should see an edit page form
    
    When I follow "Website"
    Then I should see a page titled "Updated section"
     And I should see "The updated section's body"
    
    When I go to the admin site sections page
    Then I should see "Updated section"
    When I follow "Updated section"
    When I press "Delete"    
    Then I should be on the admin site sections page
     And I should see "Sections"
     And I should not see "Updated section"
    