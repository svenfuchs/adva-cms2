Feature: Categorizing blog posts
  Background:
    Given a site with a blog named "Blog"
      And the following categories:
        | section | name          |
        | Blog    | Programming   |
        | Blog    | Design        |
      And the following posts:
        | section | categories  | title                  |
        | Blog    |             | Uncategorized post     |
        | Blog    | Programming | Post about programming |
        | Blog    | Design      | Post about design      |
    Given I am signed in with "admin@admin.org" and "admin!"
      And I am on the admin "Blog" section page

  Scenario: Categorizing an uncategorized post
    When I follow "Uncategorized post"
    Then I should see a post edit form
     And I should see "Categories" in the sidebar
    When I check "Programming"
     And I press "Update post"
    Then I should see a post edit form
     And "Programming" should be checked
     But "Design" should not be checked
     And the post titled "Uncategorized post" should be categorized as "Programming"
     And the post titled "Uncategorized post" should not be categorized as "Design"
    When I go to /
    Then I should see "Uncategorized post"
     And I should see "Post about programming"
     And I should see "Post about design"
    When I go to /categories/programming
    Then I should see "Uncategorized post"
     And I should see "Post about programming"
     But I should not see "Post about design"
    When I go to /categories/design
    Then I should not see "Uncategorized post"
     And I should not see "Post about programming"
     But I should see "Post about design"

  Scenario: Uncategorizing a categorized post
    When I follow "Post about programming"
    Then I should see a post edit form
     And I should see "Categories" in the sidebar
     And "Programming" should be checked
    When I uncheck "Programming"
     And I press "Update post"
    Then I should see a post edit form
     And "Programming" should not be checked
     And "Design" should not be checked
     And the post titled "Post about programming" should not be categorized as "Programming"
     And the post titled "Post about programming" should not be categorized as "Design"
     When I check "Programming"
     When I check "Design"
      And I press "Update post"
      And "Programming" should be checked
      But "Design" should be checked
      And the post titled "Post about programming" should be categorized as "Programming"
      And the post titled "Post about programming" should be categorized as "Design"
      When I uncheck "Design"
       And I press "Update post"
       And "Programming" should be checked
       But "Design" should not be checked
       And the post titled "Post about programming" should be categorized as "Programming"
       And the post titled "Post about programming" should not be categorized as "Design"

