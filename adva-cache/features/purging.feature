Feature: Purging tagged entries from the cache

  Background:
    Given a site with the following sections:
       | id | type | name |
       | 1  | Page | Home |
       | 2  | Blog | Blog |
     And the following posts:
       | id | section | title      | published_at |
       | 2  | Blog    | Post title | 2010-01-01   |
     And I have visited /
     And I have visited /blog
     And I have visited /blog/2010/01/01/post-title
     And I am signed in as admin
     And I don't follow any http redirects

  Scenario: Updating a site purges cache entries
    Given I am on the admin dashboard page
    When I follow "Settings"
     And I fill in "Title" with "Updated title"
     And I press "Update"
    Then it should purge cache entries tagged: site-1:title
     And it should purge the cache entries: /, /blog, /blog/2010/01/01/post-title

  Scenario: Creating a page purges cache entries
    Given I am on the admin sections page
    When I follow "New"
     And I fill in "Name" with "New page"
     And I press "Create"
     Then it should purge cache entries tagged: site-1:pages, site-1:sections
     And it should purge the cache entries: /, /blog, /blog/2010/01/01/post-title

  Scenario: Updating a page purges cache entries
    Given I am on the admin "Home" section page
    When I fill in "Name" with "Updated Home"
     And I press "Update"
    Then it should purge cache entries tagged: page-1:name, page-1:options
     And it should purge the cache entries: /

  Scenario: Deleting a page purges cache entries
    Given I am on the admin "Home" section page
    When I follow "Delete"
    Then it should purge cache entries tagged: site-1:pages, site-1:sections, page-1
     And it should purge the cache entries: /, /blog, /blog/2010/01/01/post-title

  Scenario: Updating a blog purges cache entries
    Given I am on the admin "Blog" section page
     And I follow "Settings" within "#actions"
    When I fill in "Name" with "Updated blog"
     And I press "Update"
    Then it should purge cache entries tagged: blog-2:name, blog-2:options
     And it should purge the cache entries: /blog, /blog/2010/01/01/post-title

  Scenario: Deleting a blog purges cache entries
    Given I am on the admin "Blog" section settings page
    When I follow "Delete"
    Then it should purge cache entries tagged: site-1:blogs, site-1:sections, blog-2
     And it should purge the cache entries: /, /blog, /blog/2010/01/01/post-title

  Scenario: Creating a blog post purges cache entries
    Given I am on the admin "Blog" section page
     And I follow "New"
    When I fill in "Title" with "New post title"
     And I press "Create"
    Then it should purge cache entries tagged: blog-2:posts
     # well, this is too greedy. it purges the other post because it is tagged as blog-2 and blog-2:posts matches.
     And it should purge the cache entries: /blog, /blog/2010/01/01/post-title

  Scenario: Updating a blog post purges cache entries
    Given I am on the admin "Blog" section page
     And I follow "Post title"
    When I fill in "Title" with "Updated title"
     And I press "Update"
    Then it should purge cache entries tagged: post-2:body_html, post-2:title, post-2:filter
     And it should purge the cache entries: /blog, /blog/2010/01/01/post-title

  Scenario: Deleting a blog post purges cache entries
    Given I am on the admin "Blog" section page
     And I follow "Post title"
    When I follow "Delete"
    Then it should purge cache entries tagged: blog-2:posts, post-2
  # well, this is too greedy. it purges the other post because it is tagged as blog-2 and blog-2:posts matches.
     And it should purge the cache entries: /blog, /blog/2010/01/01/post-title


