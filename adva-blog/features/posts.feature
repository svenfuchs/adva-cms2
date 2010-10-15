Feature: Managing posts

  Background:
    Given a site with the following sections:
      | type | name |
      | Blog | Blog |
    And the following posts:
      | section | title      | body      |
      | Blog    | Post title | Post body |
    And I am signed in with "admin@admin.org" and "admin!"
    And I am on the admin "Blog" section page

  Scenario: Listing posts
    Then the title should be "Posts: Index"
    Then I should see a posts list
    And I should see "Post title"

  Scenario: Viewing a post on the website from the admin posts list
    When I follow "View" within the "Post title" row
    Then I should see "Blog"
     And I should see "Post title"
     And I should see "Post body"

  Scenario: Viewing a post on the website from the admin post page
    When I follow "Post title"
     And I follow "Website"
    Then I should see "Blog"
     And I should see "Post title"
     And I should see "Post body"

  Scenario Outline: Creating a post
    When I follow "New Post"
    Then the title should be "Posts: New"
     And I should see a new post form
    When I fill in the following:
      | title | <title> |
      | body  | <body>  |
     And I press "Create post"
    Then I should see "<message>"
     And I should see an <action> post form with the following values:
      | title | <title> |
      | body  | <body>  |
    Examples:
      | title          | body          | message                   | action |
      | New post title | New post body | Post successfully created | edit   |
      | New post title |               | Post successfully created | edit   |
      |                | New post body | Post could not be created | new    |

  Scenario Outline: Updating a post's settings
    When I follow "Post title"
    Then the title should be "Posts: Edit"
    Then I should see an edit post form
    When I fill in the following:
      | title | <title> |
      | body  | <body>  |
     And I press "Update post"
    Then I should see "<message>"
     And I should see a edit post form with the following values:
      | title | <title> |
      | body  | <body>  |
    Examples:
      | title              | body              | message                   |
      | Updated post title | Updated post body | Post successfully updated |
      | Updated post title |                   | Post successfully updated |
      |                    | Updated post body | Post could not be updated |

  Scenario: Deleting a post from the admin posts list
    When I follow "Delete" within the "Post title" row
    Then the title should be "Posts: Index"
     And I should see "Post successfully deleted"

  Scenario: Deleting a post from the admin post page
    When I follow "Post title"
    When I follow "Delete"
    Then the title should be "Posts: Index"
     And I should see "Post successfully deleted"
