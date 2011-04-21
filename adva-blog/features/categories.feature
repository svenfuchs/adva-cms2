Feature: Managing blog categories
  Background:
    Given a site with a blog named "Blog"
      And the following categories:
        | section | name          |
        | Blog    | Programming   |
        | Blog    | Design        |
        | Blog    | Miscellaneous |
      And the following posts:
        | section | categories  | title                  |
        | Blog    |             | Uncategorized post     |
        | Blog    | Programming | Post about programming |
        | Blog    | Design      | Post about design      |
    Given I am signed in with "admin@admin.org" and "admin!"
      And I am on the admin "Blog" section categories page

  Scenario: Viewing blog post index page filtered by a catagory
    When I follow "Programming"
     And I follow "Website"
    Then I should see "Post about programming"
     But I should not see "Post about design"
     And I should not see "Uncategorized post"

  Scenario Outline: Creating a category
    When I follow "New"
    Then I should see a new category form
    When I fill in "Name" with "<name>"
     And I press "Create category"
    Then I should see "<message>"
     And I should see an <action> category form with the following values:
      | name | <name> |
    When I follow "Categories"
    Then I should see a categories list
     And I should see "<name>"
    Examples:
      | name     | message                       | action |
      | Business | Category successfully created | edit   |
      |          | Category could not be created | new    |

  Scenario Outline: Updating a category
    When I follow "Programming"
    Then I should see an edit category form
    When I fill in "Name" with "<name>"
     And I press "Update category"
    Then I should see "<message>"
     And I should see a edit category form with the following values:
      | name | <name> |
    When I follow "Categories"
    Then I should see a categories list
     And I should see "<name>"
    Examples:
      | name        | message                       |
      | Development | Category successfully updated |
      |             | Category could not be updated |

  Scenario: Deleting a category from the admin categories list
    When I follow "Delete" within the "Programming" row
    Then I should see "Category successfully deleted"
     And I should be on the admin "Blog" section categories page
     And I should see a categories list
     But I should not see "Programming"

  Scenario: Deleting a category from the admin category page
    When I follow "Programming"
    When I follow "Delete"
    Then I should see "Category successfully deleted"
     And I should be on the admin "Blog" section categories page
     And I should see a categories list
     But I should not see "Programming"

  Scenario: Sorting a blog's categories
    When I drag the category "Programming" below the category "Miscellaneous"
    Then I should see a "categories" table with the following entries:
      | Category      |
      | Design        |
      | Miscellaneous |
      | Programming   |
