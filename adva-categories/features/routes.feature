Feature: Routes
  Scenario: Routes
    Given the routes are loaded
    And a site with a blog named "Blog"
    And a category named "Foo" belonging to the blog "Blog"

    Then the following routes should be recognized:
      | method | path                                  | controller | action  | params                                                                |

      # adva-categories
      | GET    | /blogs/2/categories/foo               | posts      | index   | blog_id: 2, category_id: 1                                            |
      | GET    | /blogs/2/categories/foo/2009          | posts      | index   | blog_id: 2, category_id: 1, year: 2009                                |
      | GET    | /blogs/2/categories/foo/2009/1        | posts      | index   | blog_id: 2, category_id: 1, year: 2009, month: 1                      |
      | GET    | /blogs/2/categories/foo/2009/1/1      | posts      | index   | blog_id: 2, category_id: 1, year: 2009, month: 1, day: 1              |
      | GET    | /blogs/2/categories/foo/2009/1/1/post | posts      | show    | blog_id: 2, category_id: 1, year: 2009, month: 1, day: 1, slug: post  |

      | GET    | /blogs/2/categories/foo.rss           | posts      | index   | blog_id: 2, category_id: 1, format: rss                               |
      | GET    | /blogs/2/categories/foo/2009.rss      | posts      | index   | blog_id: 2, category_id: 1, format: rss, year: 2009                   |
      | GET    | /blogs/2/categories/foo/2009/1.rss    | posts      | index   | blog_id: 2, category_id: 1, format: rss, year: 2009, month: 1         |
      | GET    | /blogs/2/categories/foo/2009/1/1.rss  | posts      | index   | blog_id: 2, category_id: 1, format: rss, year: 2009, month: 1, day: 1 |

