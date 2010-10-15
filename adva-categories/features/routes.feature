Feature: Routes
  Scenario: Routes
    Given the routes are loaded
    And a site with a blog named "Blog"
    And a category named "Foo" belonging to the blog "Blog"

    Then the following routes should be recognized:
      | method | path                                        | controller       | action  | params                                                                |

      # adva-categories
      | GET    | /blogs/1/categories/foo                     | posts            | index   | blog_id: 1, category_id: 1                                            |
      | GET    | /blogs/1/categories/foo/2010                | posts            | index   | blog_id: 1, category_id: 1, year: 2010                                |
      | GET    | /blogs/1/categories/foo/2010/1              | posts            | index   | blog_id: 1, category_id: 1, year: 2010, month: 1                      |
      | GET    | /blogs/1/categories/foo/2010/1/1            | posts            | index   | blog_id: 1, category_id: 1, year: 2010, month: 1, day: 1              |
      | GET    | /blogs/1/categories/foo/2010/1/1/post       | posts            | show    | blog_id: 1, category_id: 1, year: 2010, month: 1, day: 1, slug: post  |

      | GET    | /blogs/1/categories/foo.rss                 | posts            | index   | blog_id: 1, category_id: 1, format: rss                               |
      | GET    | /blogs/1/categories/foo/2010.rss            | posts            | index   | blog_id: 1, category_id: 1, format: rss, year: 2010                   |
      | GET    | /blogs/1/categories/foo/2010/1.rss          | posts            | index   | blog_id: 1, category_id: 1, format: rss, year: 2010, month: 1         |
      | GET    | /blogs/1/categories/foo/2010/1/1.rss        | posts            | index   | blog_id: 1, category_id: 1, format: rss, year: 2010, month: 1, day: 1 |

      | GET    | /admin/sites/1/sections/1/categories        | admin/categories | index   | site_id: 1, section_id: 1            |
      | POST   | /admin/sites/1/sections/1/categories        | admin/categories | create  | site_id: 1, section_id: 1            |
      | GET    | /admin/sites/1/sections/1/categories/new    | admin/categories | new     | site_id: 1, section_id: 1            |
      | GET    | /admin/sites/1/sections/1/categories/1      | admin/categories | show    | site_id: 1, section_id: 1, id: 1     |
      | PUT    | /admin/sites/1/sections/1/categories/1      | admin/categories | update  | site_id: 1, section_id: 1, id: 1     |
      | DELETE | /admin/sites/1/sections/1/categories/1      | admin/categories | destroy | site_id: 1, section_id: 1, id: 1     |
      | GET    | /admin/sites/1/sections/1/categories/1/edit | admin/categories | edit    | site_id: 1, section_id: 1, id: 1     |

