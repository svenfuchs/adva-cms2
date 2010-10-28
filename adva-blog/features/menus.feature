Feature: Menus

  Background:
    Given a site with a blog named "Blog"
    And the following posts:
      | section | title      | body      |
      | Blog    | Post title | Post body |
    And the following categories:
      | section | name        |
      | Blog    | Programming |
    And I am signed in with "admin@admin.org" and "admin!"

  Scenario: Admin Blogs
    When I go to the admin "Blog" section settings page
    Then the menu should contain the following items:
      | text     | url                              | active | menu            |
      | adva-cms |                                  |        | #top .main      |
      | adva-cms | /admin/sites/1                   | yes    | #top .main      |
      | Sections | /admin/sites/1/sections          | yes    | #top .main      |
      | Blog     | /admin/sites/1/blogs/1           | yes    | #top .main      |
      | Settings | /admin/sites/1/edit              |        | #top .right     |
      | Blog     |                                  |        | #actions .main  |
      | Posts    | /admin/sites/1/blogs/1/posts     |        | #actions .main  |
      | Settings | /admin/sites/1/blogs/1/edit      | yes    | #actions .main  |
      | New Post | /admin/sites/1/blogs/1/posts/new |        | #actions .right |
      | Delete   | /admin/sites/1/blogs/1           |        | #actions .right |

  Scenario: Admin Blogs Categories
    When I go to the admin "Blog" section settings page
    When I follow "Categories"
    Then the menu should contain the following items:
      | text         | url                                      | active | menu            |
      | adva-cms     |                                          |        | #top .main      |
      | adva-cms     | /admin/sites/1                           | yes    | #top .main      |
      | Sections     | /admin/sites/1/sections                  | yes    | #top .main      |
      | Blog         | /admin/sites/1/blogs/1                   | yes    | #top .main      |
      | Settings     | /admin/sites/1/edit                      |        | #top .right     |
      | Blog:        |                                          |        | #actions .main  |
      | Categories   | /admin/sites/1/sections/1/categories     | yes    | #actions .main  |
      | New Category | /admin/sites/1/sections/1/categories/new |        | #actions .right |
      
  Scenario: Admin Blogs Categories Edit
    When I go to the admin "Blog" section settings page
    When I follow "Categories"
    When I follow "Programming"    
    Then show me the page
    Then the menu should contain the following items:
      | text         | url                                      | active | menu            |
      | adva-cms     |                                          |        | #top .main      |
      | adva-cms     | /admin/sites/1                           | yes    | #top .main      |
      | Sections     | /admin/sites/1/sections                  | yes    | #top .main      |
      | Blog         | /admin/sites/1/blogs/1                   | yes    | #top .main      |
      | Settings     | /admin/sites/1/edit                      |        | #top .right     |
      | Blog:        |                                          |        | #actions .main  |
      | Categories   | /admin/sites/1/sections/1/categories     | yes    | #actions .main  |
      | New Category | /admin/sites/1/sections/1/categories/new |        | #actions .right |
      | Delete       | /admin/sites/1/sections/1/categories/1   |        | #actions .right |      

  Scenario: Admin Posts
    When I go to the admin edit post page for the post "Post title"
    Then the menu should contain the following items:
      | text     | url                                          | active | menu            |
      | adva-cms |                                              |        | #top .main      |
      | adva-cms | /admin/sites/1                               | yes    | #top .main      |
      | Sections | /admin/sites/1/sections                      | yes    | #top .main      |
      | Blog     | /admin/sites/1/blogs/1                       | yes    | #top .main      |
      | Settings | /admin/sites/1/edit                          |        | #top .right     |
      | Blog     |                                              |        | #actions .main  |
      | Posts    | /admin/sites/1/blogs/1/posts                 | yes    | #actions .main  |
      | Settings | /admin/sites/1/blogs/1/edit                  |        | #actions .main  |
      | New Post | /admin/sites/1/blogs/1/posts/new             |        | #actions .right |
      | View     | http://www.example.com/2010/09/08/post-title |        | #actions .right |
      | Edit     | /admin/sites/1/blogs/1/posts/1/edit          | yes    | #actions .right |
      | Delete   | /admin/sites/1/blogs/1/posts/1               |        | #actions .right |

