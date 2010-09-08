Feature: Menus
  Scenario: Admin Blogs
    Given I am signed in with "admin@admin.org" and "admin"
    And a blog titled "Blog"
    And I am on the admin "Blog" section page
    Then the menu should contain the following items:
      | text     | url                              | active | menu            |
      | Sites    | /admin/sites                     |        | #top .left      |
      | Sections | /admin/sites/1/sections          | yes    | #top .left      |
      | Blog     | /admin/sites/1/blogs/1           | yes    | #top .left      |
      | Settings | /admin/sites/1/edit              |        | #top .right     |
      | Blog:    |                                  |        | #actions .left  |
      | Posts    | /admin/sites/1/blogs/1           | yes    | #actions .left  |
      | New Post | /admin/sites/1/blogs/1/posts/new |        | #actions .right |
      | Delete   | /admin/sites/1/blogs/1           |        | #actions .right |

  Scenario: Admin Posts
    Given I am signed in with "admin@admin.org" and "admin"
    And a blog titled "Blog"
    And a post with the title "Post" for the blog "Blog"
    And I am on the admin edit post page for the post "Post"
    Then the menu should contain the following items:
      | text     | url                                         | active | menu            |
      | Sites    | /admin/sites                                |        | #top .left      |
      | Sections | /admin/sites/1/sections                     | yes    | #top .left      |
      | Blog     | /admin/sites/1/blogs/1                      | yes    | #top .left      |
      | Settings | /admin/sites/1/edit                         |        | #top .right     |
      | Blog:    |                                             |        | #actions .left  |
      | Posts    | /admin/sites/1/blogs/1                      | yes    | #actions .left  |
      | New      | /admin/sites/1/blogs/1/posts/new            |        | #actions .right |
      | View     | http://www.example.com/blog/2010/09/08/post |        | #actions .right |
      | Edit     | /admin/sites/1/blogs/1/posts/1/edit         | yes    | #actions .right |
      | Delete   | /admin/sites/1/blogs/1/posts/1              |        | #actions .right |
