Feature: Managing pages
  Scenario: Creating a new page
    Given I am signed in with "admin@admin.org" and "admin"
    Given I am on the admin dashboard page

    When I follow "New section"
    Then I should see a section type form
     And the "Page" radio button should be checked
     And I should see a new page form
    When I fill in "Title" with "Brand new page"
     And I fill in "Heading" with "The brand new page's heading"
     And I fill in "Body" with "The brand new page's body"
     And I press "Create page"
    Then I should see an edit article form
    When I fill in "Heading" with "Updated page's heading"
    When I fill in "Body" with "Updated page's body"
    When I press "Update article"
    Then I should see an edit article form
    
    When I follow "Website"
    # Then I should see a page titled "Updated page's heading"
    Then I should see "Updated page's body"
    
    When I go to the admin site sections page
    Then I should see "Brand new page"
    When I follow "Brand new page"
    Then I should see an edit article form

    When I follow "Settings"
    Then I should see an edit page form
    
    When I press "Delete"
    Then I should be on the admin site sections page
     And I should see "Sections"
     And I should not see "Updated section"
    