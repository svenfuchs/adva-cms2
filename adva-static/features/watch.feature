Feature: Updating the database based on changes to the import source files
  Background:
    Given an empty import directory "www.example.com"
     And an empty export directory
     And a site with the following sections:
      | type | name |
      | blog | Home |
      | blog | Blog |

  Scenario Outline: Editing an existing blog post source file
    Given a post with the following attributes:
      | id         | 1          |
      | section    | <blog>     |
      | title      | Post title |
      | body       | Post body  |
      | created_at | 2010-1-1   |
     And a source file "<blog_source>" with the following values:
      | name  | <blog> |
     And a source file "<post_source>"
     And the following urls are tagged:
      | url            | tags   |
      | /<post_target> | post-1 |
     And a watcher has started
    When I update the file "<post_source>" with the following values triggering the watcher:
      | title | Post title        |
      | body  | Updated post body |
    Then the watcher should "PUT" the following "post" params for the file "<post_source>":
      | title      | Post title        |
      | body       | Updated post body |
      | created_at | 2010-1-1          |
      | site_id    | adva-cms          |
      | section_id | <blog>            |
     And there should be an export file "<post_target>" containing "Updated post body"
    Examples:
      | blog | blog_source | post_source                  | post_target                     | comment                    |
      | Home |             | 2010-1-1-post-title.yml      | 2010/01/01/post-title.html      | an anonymous root blog     |
      | Home | index.yml   | 2010-1-1-post-title.yml      | 2010/01/01/post-title.html      | a defined root blog        |
      | Blog |             | blog/2010-1-1-post-title.yml | blog/2010/01/01/post-title.html | an anonymous non-root blog |
      | Blog | blog.yml    | blog/2010-1-1-post-title.yml | blog/2010/01/01/post-title.html | a defined non-root blog    |

  Scenario Outline: Creating a source file
    Given a watcher has started
    When I create the file "<post_source>" with the following values triggering the watcher:
      | title | New post title |
      | body  | New post body  |
    Then the watcher should "POST" the following "post" params for the file "<post_source>":
      | title      | New post title    |
      | body       | New post body     |
      | created_at | 2010-1-1          |
      | site_id    | adva-cms          |
      | section_id | <blog>            |
     And there should be an export file "<post_target>" containing "New post body"
    Examples:
      | blog | post_source                  | post_target                     |
      | Home | 2010-1-1-post-title.yml      | 2010/01/01/post-title.html      |
      | Blog | blog/2010-1-1-post-title.yml | blog/2010/01/01/post-title.html |


  Scenario Outline: Deleting a source file
    Given a post with the following attributes:
      | id         | 1          |
      | section    | <blog>     |
      | title      | Post title |
      | body       | Post body  |
      | created_at | 2010-1-1   |
     And a source file "<post_source>" with the following values:
      | title | Post title        |
      | body  | Updated post body |
     And the following urls are tagged:
      | url            | tags   |
      | /<post_target> | post-1 |
     And a watcher has started
    When I delete the file "<post_source>" triggering the watcher
    Then the watcher should "DELETE" the following "post" params for the file "<post_source>":
      | id | 1 |
     And there should not be an export file "<post_target>"
    Examples:
      | blog | post_source                  | post_target                     |
      | Home | 2010-1-1-post-title.yml      | 2010/01/01/post-title.html      |
      | Blog | blog/2010-1-1-post-title.yml | blog/2010/01/01/post-title.html |


  # Scenario: Changing the name of a blog
  #   Given an empty import directory "www.example.com"
  #    And a site with a blog named "Blog"
  #    And a source file "blog/2010-1-1-post-title.yml"
  #    And a source file "blog.yml" with the following values:
  #     | name  | Updated blog name |
  #   Then the watcher should "PUT" the following "blog" params for the file "blog.yml":
  #     | name  | Updated blog name |

  # Scenario: Changing the title of a blog post
  #   Given an empty import directory "www.example.com"
  #   And a site with a blog named "Home"
  #   And a post with the following attributes:
  #     | section    | Home       |
  #     | title      | Post title |
  #     | body       | Post body  |
  #     | created_at | 2010-1-1   |
  #    And a source file "2010-1-1-post.yml" with the following values:
  #     | title | Updated post title |
  #     | body  | Post body          |
  #   Then the watcher should "PUT" the following "post" params for the file "2010-1-1-post.yml":
  #     | title      | Updated post title |
  #     | body       | Post body          |
  #     | created_at | 2010-1-1           |
  #     | site_id    | adva-cms           |
  #     | section_id | Home               |
