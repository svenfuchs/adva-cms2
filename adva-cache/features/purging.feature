Feature: Purging tagged pages from the cache
  Background:
    Given a site with the following sections:
       | id | type | name |
       | 1  | Page | FAQ  |
       | 2  | Blog | Blog |
     And the following posts:
       | id | section | title      | created_at |
       | 1  | Blog    | Post title | 2010-01-01 |
     And I have visited /
     And I have visited /blog
     And I have visited /blog/2010/01/01/post-title
     And I am signed in with "admin@admin.org" and "admin"
     And I don't follow any http redirects

  Scenario: Updating a site purges cache entries
    Given I am on the admin dashboard page
    When I follow "Settings"
     And I fill in "Title" with "Updated title"
     And I press "Update"
    Then it should purge cache entries tagged: site-1:title
     And it should purge the cache entries: /, /blog, /blog/2010/01/01/post-title

  Scenario: Updating a page purges cache entries
    Given I am on the admin "FAQ" section page
    When I fill in "Name" with "Updated FAQ"
     And I press "Update"
    Then it should purge cache entries tagged: page-1:name
     And it should purge the cache entries: /

  Scenario: Updating a blog purges cache entries
    Given I am on the admin "Blog" section page
     And I follow "Settings" within "#actions"
    When I fill in "Name" with "Updated blog"
     And I press "Update"
    Then it should purge cache entries tagged: blog-2:name, blog-2:options
     And it should purge the cache entries: /blog, /blog/2010/01/01/post-title

  Scenario: Updating a blog post purges cache entries
    Given I am on the admin "Blog" section page
     And I follow "Post title"
    When I fill in "Title" with "Updated title"
     And I press "Update"
    Then it should purge cache entries tagged: post-1:title, post-1:filter
     And it should purge the cache entries: /blog, /blog/2010/01/01/post-title
