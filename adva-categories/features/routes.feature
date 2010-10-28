Feature: Routes
  Scenario: Routes
    Given the routes are loaded
    And a site with a blog named "Blog 1"
    And a blog named "Blog 2"
    And a category named "Foo" belonging to the blog "Blog 1"
    And a category named "Bar" belonging to the blog "Blog 2"

    Then the following routes should be recognized:
      | method | path                                        | controller       | action  | params                                                                |

      # adva-categories
      | GET    | /categories/foo                             | posts            | index   | blog_id: 1, category_id: 1                                            |
      | GET    | /categories/foo/2010                        | posts            | index   | blog_id: 1, category_id: 1, year: 2010                                |
      | GET    | /categories/foo/2010/1                      | posts            | index   | blog_id: 1, category_id: 1, year: 2010, month: 1                      |
      | GET    | /categories/foo/2010/1/1                    | posts            | index   | blog_id: 1, category_id: 1, year: 2010, month: 1, day: 1              |
      | GET    | /categories/foo/2010/1/1/post               | posts            | show    | blog_id: 1, category_id: 1, year: 2010, month: 1, day: 1, slug: post  |
      | GET    | /categories/foo.rss                         | posts            | index   | blog_id: 1, category_id: 1, format: rss                               |
      | GET    | /categories/foo/2010.rss                    | posts            | index   | blog_id: 1, category_id: 1, format: rss, year: 2010                   |
      | GET    | /categories/foo/2010/1.rss                  | posts            | index   | blog_id: 1, category_id: 1, format: rss, year: 2010, month: 1         |
      | GET    | /categories/foo/2010/1/1.rss                | posts            | index   | blog_id: 1, category_id: 1, format: rss, year: 2010, month: 1, day: 1 |

      | GET    | /blog-2/categories/bar                      | posts            | index   | blog_id: 2, category_id: 2                                            |
      | GET    | /blog-2/categories/bar/2010                 | posts            | index   | blog_id: 2, category_id: 2, year: 2010                                |
      | GET    | /blog-2/categories/bar/2010/1               | posts            | index   | blog_id: 2, category_id: 2, year: 2010, month: 1                      |
      | GET    | /blog-2/categories/bar/2010/1/1             | posts            | index   | blog_id: 2, category_id: 2, year: 2010, month: 1, day: 1              |
      | GET    | /blog-2/categories/bar/2010/1/1/post        | posts            | show    | blog_id: 2, category_id: 2, year: 2010, month: 1, day: 1, slug: post  |
      | GET    | /blog-2/categories/bar.rss                  | posts            | index   | blog_id: 2, category_id: 2, format: rss                               |
      | GET    | /blog-2/categories/bar/2010.rss             | posts            | index   | blog_id: 2, category_id: 2, format: rss, year: 2010                   |
      | GET    | /blog-2/categories/bar/2010/1.rss           | posts            | index   | blog_id: 2, category_id: 2, format: rss, year: 2010, month: 1         |
      | GET    | /blog-2/categories/bar/2010/1/1.rss         | posts            | index   | blog_id: 2, category_id: 2, format: rss, year: 2010, month: 1, day: 1 |

      | GET    | /admin/sites/1/sections/1/categories        | admin/categories | index   | site_id: 1, section_id: 1            |
      | POST   | /admin/sites/1/sections/1/categories        | admin/categories | create  | site_id: 1, section_id: 1            |
      | GET    | /admin/sites/1/sections/1/categories/new    | admin/categories | new     | site_id: 1, section_id: 1            |
      | GET    | /admin/sites/1/sections/1/categories/1      | admin/categories | show    | site_id: 1, section_id: 1, id: 1     |
      | PUT    | /admin/sites/1/sections/1/categories/1      | admin/categories | update  | site_id: 1, section_id: 1, id: 1     |
      | DELETE | /admin/sites/1/sections/1/categories/1      | admin/categories | destroy | site_id: 1, section_id: 1, id: 1     |
      | GET    | /admin/sites/1/sections/1/categories/1/edit | admin/categories | edit    | site_id: 1, section_id: 1, id: 1     |

