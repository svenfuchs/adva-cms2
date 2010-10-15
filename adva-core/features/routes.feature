Feature: Routes

  Scenario: Routes
    Given the routes are loaded
    And a site with a blog named "Blog"
    And a category named "Foo" belonging to the blog "Blog"

    Then the following routes should be recognized:
      | method | path                                      | controller          | action  | params                                              |

      # adva-core
      | POST   | /installations                            | installations       | create  |                                                     |
      | GET    | /installations/new                        | installations       | new     |                                                     |
      | GET    | /pages/1                                  | pages               | show    | id: 1                                               |
      | GET    | /pages/1/article                          | articles            | show    | page_id: 1                                          |

      | GET    | /admin/sites                              | admin/sites         | index   |                                                     |
      | POST   | /admin/sites                              | admin/sites         | create  |                                                     |
      | GET    | /admin/sites/new                          | admin/sites         | new     |                                                     |
      | GET    | /admin/sites/1                            | admin/sites         | show    | id: 1                                               |
      | PUT    | /admin/sites/1                            | admin/sites         | update  | id: 1                                               |
      | DELETE | /admin/sites/1                            | admin/sites         | destroy | id: 1                                               |
      | GET    | /admin/sites/1/edit                       | admin/sites         | edit    | id: 1                                               |

      | GET    | /admin/sites/1/sections                   | admin/sections      | index   | site_id: 1                                          |
      | POST   | /admin/sites/1/sections                   | admin/sections      | create  | site_id: 1                                          |
      | GET    | /admin/sites/1/sections/new               | admin/sections      | new     | site_id: 1                                          |
