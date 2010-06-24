Feature: Managing blogs
  Scenario: Creating a new blog
    Given I am signed in
    Given I am on the admin dashboard page

    When I follow "New section"
    Then I should see a section type form
     And the "Page" radio button should be checked
     And the "Blog" radio button should not be checked
     And I should see a new page form
     
    When I choose "Blog"
     And I press "Select"
    Then I should see a section type form
     And the "Page" radio button should not be checked
     And the "Blog" radio button should be checked
     And I should see a new blog form
     
    When I fill in "Title" with "Brand new blog"
     And I press "Create"
    Then I should see an edit blog form

    # When I fill in "Title" with "Updated blog"
    # When I press "Save"
    # Then I should see an edit section form
    # 
    # When I follow "Website"
    # Then I should see a blog
    #  And I should see an empty articles list
    # 
    # When I go to the admin site sections page
    # Then I should see "Updated blog"
    # When I follow "Updated blog"
    #  And I follow "New"
    # Then I should see a create article form
    # 
    # When I fill in "Heading" with "Brand new blog post"
    #  And I fill in "Body" with "Brand new blog post's body"
    #  And I press "Save"
    # Then I should see an edit article form
    # 
    # When I fill in "Heading" with "Updated blog post"
    #  And I fill in "Body" with "Updated blog post's body"
    #  And I press "Save"
    # 
    # When I follow "Website"
    # Then I should see an article titled "Updated blog post"
    #  And I should see "Updated blog post's body"
    # 
    # When I go to the admin site sections page
    #  And I follow "Updated blog"
    #  And I follow "Updated blog post"
    # Then I should see an edit article form
    # 
    # When I press "Delete"    
    # Then I should see "Updated blog"
    #  And I should see an empty articles list
    #  And I should not see "Updated blog post"
