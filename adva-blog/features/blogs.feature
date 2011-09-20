Feature: Managing blogs

  Background:
    Given a site with the following sections:
      | type | name |
      | Page | Home |
      | Blog | Blog |
    And the following posts:
      | section | title      | body      |
      | Blog    | Post title | Post body |
    And I am signed in as admin
    And I am on the admin sections page

  Scenario: Listing blogs as sections
    Then the title should be "Sections: Index"
    Then I should see a sections list
     And I should see "Blog"

  Scenario: Viewing a blog on the website from the admin sections list
    When I follow "View" within the "Blog" row
    Then I should see "Blog"
     And I should see "Post title"
     And I should see "Post body"

  Scenario: Viewing a blog on the website from the admin section page
    When I follow "Blog"
     And I follow "Website"
    Then I should see "Blog"
     And I should see "Post title"
     And I should see "Post body"

  Scenario Outline: Creating a blog
    When I follow "New Section"
    Then the title should be "Pages: New"
     And I should see a section type form
    When I choose "Blog"
     And I press "Select"
    Then the title should be "Blogs: New"
     And the "Blog" radio button should be checked
     And I should see a new blog form
    When I fill in "Name" with "<name>"
     And I press "Create Blog"
    Then I should see "<message>"
     And I should see "<name>"
     And I should see <result>
    Examples:
      | name     | message                   | result       |
      | New name | Blog successfully created | a posts list |
      |          | Blog could not be created | a blog form  |

  Scenario Outline: Updating a blog's settings
    When I follow "Blog"
     And I follow "Settings" within "#actions"
    Then the title should be "Blogs: Edit"
    Then I should see an edit blog form
    When I fill in "Name" with "<name>"
     And I press "Update Blog"
    Then I should see "<message>"
     And I should see an edit blog form
     And "Name" should be filled in with "<name>"
    Examples:
      | name         | message                   |
      | Updated name | Blog successfully updated |
      |              | Blog could not be updated |

  Scenario: Deleting a blog from the admin sections list
    When I follow "Delete" within the "Blog" row
    Then the title should be "Sections: Index"
     And I should see "Blog successfully deleted"

  Scenario: Deleting a blog from the admin section settings page
    When I follow "Blog"
     And I follow "Settings" within "#actions"
    When I follow "Delete"
    Then the title should be "Sections: Index"
     And I should see "Blog successfully deleted"
