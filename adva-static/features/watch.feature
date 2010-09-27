Feature: Updating the database based on changes to the import source files

  Scenario Outline: Editing an existing blog post source file
    Given an empty import directory "www.example.com"
     And a site with a blog named "<blog>"
     And a post with the following attributes:
      | section    | <blog>     |
      | title      | Post title |
      | body       | Post body  |
      | created_at | 2010-1-1   |
     And a source file "<blog_source>" with the following values:
      | name  | <blog> |
     And a source file "<post_source>" with the following values:
      | title | Post title        |
      | body  | Updated post body |
    Then the watcher should "PUT" the following "post" params for the file "<post_source>":
      | title      | Post title        |
      | body       | Updated post body |
      | created_at | 2010-1-1          |
      | site_id    | adva-cms          |
      | section_id | <blog>            |
    Examples:
      | blog | blog_source | post_source                  | comment                    |
      | Home |             | 2010-1-1-post-title.yml      | an anonymous root blog     |
      | Home | index.yml   | 2010-1-1-post-title.yml      | a defined root blog        |
      | Blog |             | blog/2010-1-1-post-title.yml | an anonymous non-root blog |
      | Blog | blog.yml    | blog/2010-1-1-post-title.yml | a defined non-root blog    |

  Scenario: Changing the name of a blog
    Given an empty import directory "www.example.com"
     And a site with a blog named "Blog"
     And a source file "blog/2010-1-1-post-title.yml"
     And a source file "blog.yml" with the following values:
      | name  | Updated blog name |
    Then the watcher should "PUT" the following "blog" params for the file "blog.yml":
      | name  | Updated blog name |

  Scenario: Changing the title of a blog post
    Given an empty import directory "www.example.com"
    And a site with a blog named "Home"
    And a post with the following attributes:
      | section    | Home       |
      | title      | Post title |
      | body       | Post body  |
      | created_at | 2010-1-1   |
     And a source file "2010-1-1-post-title.yml" with the following values:
      | title | Updated post title |
      | body  | Post body          |
    Then the watcher should "PUT" the following "post" params for the file "2010-1-1-post-title.yml":
      | title      | Updated post title |
      | body       | Post body          |
      | created_at | 2010-1-1           |
      | site_id    | adva-cms           |
      | section_id | Home               |