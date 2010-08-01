Feature: Managing blogs
  Scenario: Creating a new blog
    Given I am signed in with "admin@admin.org" and "admin"
    Given I am on the admin dashboard page

    When I follow "New section"
    Then I should see a new page form
     And the "Page" radio button should be checked
     And the "Blog" radio button should not be checked
     
    When I choose "Blog"
     And I press "Select"
    Then I should see a new blog form
     And the "Page" radio button should not be checked
     And the "Blog" radio button should be checked
     And I fill in "Title" with "Brand new blog"
     And I press "Create blog"
    Then I should be on the admin posts list page of the "Brand new blog" blog
     But I should not see any posts
    When I follow "Settings"
     And I fill in "Title" with "Updated blog"
    When I press "Update blog"
    Then I should see an edit blog form
    
    When I follow "Website"
    Then I should see a blog
     And I should not see any posts
    
    When I go to the admin site sections page
    Then I should see "Updated blog"
    When I follow "Updated blog"
     And I follow "New"
    Then I should see a new post form
    
    When I fill in "Title" with "Brand new blog post"
     And I fill in "Body" with "Brand new blog post's body"
     And I press "Create"
    Then I should see an edit post form
    
    When I fill in "Title" with "Updated blog post"
     And I fill in "Body" with "Updated blog post's body"
     And I press "Save"
    Then I should see an edit post form
    
    When I follow "Website"
    Then I should see a post titled "Updated blog post"
     And I should see a post containing "Updated blog post's body"
    When I follow "Updated blog"
    Then I should see "Updated blog post"
    
    When I go to the admin site sections page
     And I follow "Updated blog"
     And I follow "Updated blog post"
    Then I should see an edit post form

    When I press "Delete"
    Then I should see "Updated blog"
     And I should not see any posts
     And I should not see "Updated blog post"
