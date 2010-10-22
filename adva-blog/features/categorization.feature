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
    When I follow "Uncategorized"
    Then I should see a post edit form
     And I should see "Categories" in the sidebar
    When I check "Programming"
     And I press "Update post"
    Then I should see a post edit form
     And "Programming" should be checked
     But "Design" should not be checked
