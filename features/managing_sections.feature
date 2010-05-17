Feature: Installing a Site, creating a section with an article
  # ... Background: no site
  
  Scenario: Creating a new page
    # Given I go to the homepage
    # Then I see the install page
    
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
    
    # And I follow "preview"
    # Then I should see be on the "brand new section" page
    
    # goes to articles/show because webrat does not know about rails 3 delete links yet
    # When I follow "delete"
    # Then I should be on the admin sections index page