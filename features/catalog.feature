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
    
    When I fill in "Title" with "Updated catalog"
    When I press "Save"
    Then I should see an edit catalog form
    
    # When I follow "Website"
    # Then I should see a blog
    #  And I should not see any posts
    # 
    # When I go to the admin site sections page
    # Then I should see "Updated blog"
    # When I follow "Updated blog"
    #  And I follow "New"
    # Then I should see a new post form
    # 
    # When I fill in "Title" with "Brand new blog post"
    #  And I fill in "Body" with "Brand new blog post's body"
    #  And I press "Create"
    # Then I should see an edit post form
    # 
    # When I fill in "Title" with "Updated blog post"
    #  And I fill in "Body" with "Updated blog post's body"
    #  And I press "Save"
    # Then I should see an edit post form
    # 
    # When I follow "Website"
    # Then I should see a post titled "Updated blog post"
    #  And I should see a post containing "Updated blog post's body"
    # When I follow "Updated blog"
    # Then I should see "Updated blog post"
    # 
    # When I go to the admin site sections page
    #  And I follow "Updated blog"
    #  And I follow "Updated blog post"
    # Then I should see an edit post form
    # 
    # When I press "Delete"
    # Then I should see "Updated blog"
    #  And I should not see any posts
    #  And I should not see "Updated blog post"
