Feature: Managing pages
  Scenario: Creating a new page
    Given I am signed in with "admin@admin.org" and "admin"
    Given I am on the admin dashboard page

    When I follow "New section"
    Then I should see a section type form
     And the "Page" radio button should be checked
     And I should see a section form
     
    When I fill in "Title" with "Brand new section"
     And I fill in "Heading" with "The brand new section's heading"
     And I fill in "Body" with "The brand new section's body"
     And I press "Create"
    Then I should see an article form
    
    When I fill in "Heading" with "Updated section's heading"
    When I fill in "Body" with "Updated section's body"
    When I press "Update Article"
    Then I should see an article form
    
    # page/1/edit settings
    
    When I follow "Website"
    Then I should see a page titled "Updated section's heading"
     And I should see "Updated section's body"
    
    When I go to the admin site sections page
    Then I should see "Brand new section"
    When I follow "Brand new section"
    Then I should see an article form

    When I follow "Settings"
    Then I should see a section form
    
    When I press "Delete"
    Then I should be on the admin site sections page
     And I should see "Sections"
     And I should not see "Updated section"
    