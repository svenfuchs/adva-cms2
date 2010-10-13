Feature: Managing categories
  Background:
    Given a site with a blog named "Blog"
      And the following categories:
        | section | name        |
        | Blog    | Programming |
        | Blog    | Design      |
      And the following posts:
        | section | categories  | title                  |
        | Blog    |             | uncategorized post     |
        | Blog    | Programming | post about programming |
        | Blog    | Design      | post about design      |

  Scenario: Foo
    Given I am signed in with "admin@admin.org" and "admin"
      And I am on the admin "Blog" section page
     Then I should see "Categories"

     # Scenario: Viewing an unfiltered blog posts list
