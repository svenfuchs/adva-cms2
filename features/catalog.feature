Feature: Managing catalogs
  Scenario: Creating a new catalog
    Given I am signed in
    Given I am on the admin dashboard page

    When I follow "New section"
    Then I should see a section type form
     And the "Page" radio button should be checked
     And the "Catalog" radio button should not be checked
     And I should see a new page form
     
    When I choose "Catalog"
     And I press "Select"
    Then I should see a section type form
     And the "Page" radio button should not be checked
     And the "Catalog" radio button should be checked
     And I should see a new catalog form
     
    When I fill in "Title" with "Brand new catalog"
     And I press "Create"
    Then I should be on the admin products list page of the "Brand new catalog" catalog
     But I should not see any products
    When I follow "Settings"
    Then I should see an edit catalog form
    
    When I fill in "Name" with "Updated catalog"
    When I press "Save"
    Then I should see an edit catalog form
    
    When I follow "Website"
    Then I should see a catalog
     And I should not see any products
    
    When I go to the admin site sections page
    Then I should see "Updated catalog"
    When I follow "Updated catalog"
     And I follow "New"
    Then I should see a new product form
    
    When I fill in "Name" with "Brand new product"
     And I fill in "Description" with "Brand new product's Description"
     And I press "Create"
    Then I should see an edit product form
    
    When I fill in "Name" with "Updated product"
     And I fill in "Description" with "Updated product's Description"
     And I press "Save"
    Then I should see an edit product form
    
    When I follow "Website"
    Then I should see a product Named "Updated product"
     And I should see a product containing "Updated product's Description"
    When I follow "Updated catalog"
    Then I should see "Updated product"
    
    When I go to the admin site sections page
     And I follow "Updated catalog"
     And I follow "Updated product"
    Then I should see an edit product form
    
    When I press "Delete"
    Then I should see "Updated catalog"
     And I should not see any products
     And I should not see "Updated product"
