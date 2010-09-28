Feature: Tagging pages for cache invalidation

  Scenario: Cache tagging a page
    Given a site
    When I go to /
    Then the following urls should be tagged:
      | url | tags                 |
      | /   | site-1:title, page-1 |

  Scenario: Cache tagging a blog
    Given a site with the following sections:
      | id |  type | name    |
      | 1  |  Blog | Blog    |
    And the following posts:
      | id |  section | title       | created_at |
      | 1  |  Blog    | First post  | 2010-01-01   |
      | 2  |  Blog    | Second post | 2010-01-02   |
    When I go to /
     And I go to /2010/01/01/first-post
     And I go to /2010/01/02/second-post
    Then the following urls should be tagged:
      | url                     | tags                                 |
      | /                       | site-1:title, blog-1, post-1, post-2 |
      | /2010/01/01/first-post  | blog-1, post-1                       |
      | /2010/01/02/second-post | blog-1, post-2                       |

    # FIXME site-1:title missing on posts#show
    #
    # apparently inherited_resources doesn't play nice with reference_tracking
    # by defining instance_variables for the association_chain (@site in this
    # case).
    