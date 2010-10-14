Feature: Menus

  Background:
    Given a site with a blog named "Blog"
    And the following posts:
      | section | title      | body      |
      | Blog    | Post title | Post body |
    And I am signed in with "admin@admin.org" and "admin!"

  Scenario: Admin Blogs
    When I go to the admin "Blog" section page
    Then the menu should contain the following items:
      | text     | url                              | active | menu            |
      | adva-cms |                                  |        | #top .main      |
      | adva-cms | /admin/sites/1                   | yes    | #top .main      |
      | Sections | /admin/sites/1/sections          | yes    | #top .main      |
      | Blog     | /admin/sites/1/blogs/1           | yes    | #top .main      |
      | Settings | /admin/sites/1/edit              |        | #top .right     |
      | Blog     |                                  |        | #actions .main  |
      | Posts    | /admin/sites/1/blogs/1           | yes    | #actions .main  |
      | New Post | /admin/sites/1/blogs/1/posts/new |        | #actions .right |
      | Delete   | /admin/sites/1/blogs/1           |        | #actions .right |

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
      | Posts    | /admin/sites/1/blogs/1                       | yes    | #actions .main  |
      | New      | /admin/sites/1/blogs/1/posts/new             |        | #actions .right |
      | View     | http://www.example.com/2010/09/08/post-title |        | #actions .right |
      | Edit     | /admin/sites/1/blogs/1/posts/1/edit          | yes    | #actions .right |
      | Delete   | /admin/sites/1/blogs/1/posts/1               |        | #actions .right |

