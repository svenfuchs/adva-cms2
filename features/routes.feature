Feature: Routes
  Scenario: Routes
    Given the routes are loaded
    Then the following routes should be recognized:
      | method | path                                      | controller          | action  | params                           |

      # adva-blog
      | GET    | /sections/1/posts                         | posts               | index   | section_id: 1                    |
      | POST   | /sections/1/posts                         | posts               | create  | section_id: 1                    |
      | GET    | /sections/1/posts/new                     | posts               | new     | section_id: 1                    |
      | GET    | /sections/1/posts/1                       | posts               | show    | section_id: 1, id: 1             |
      | PUT    | /sections/1/posts/1                       | posts               | update  | section_id: 1, id: 1             |
      | DELETE | /sections/1/posts/1                       | posts               | destroy | section_id: 1, id: 1             |
      | GET    | /sections/1/posts/1/edit                  | posts               | edit    | section_id: 1, id: 1             |

      | GET    | /admin/sites/1/sections/1/posts           | admin/posts         | index   | site_id: 1, section_id: 1        |
      | POST   | /admin/sites/1/sections/1/posts           | admin/posts         | create  | site_id: 1, section_id: 1        |
      | GET    | /admin/sites/1/sections/1/posts/new       | admin/posts         | new     | site_id: 1, section_id: 1        |
      | GET    | /admin/sites/1/sections/1/posts/1         | admin/posts         | show    | site_id: 1, section_id: 1, id: 1 |
      | PUT    | /admin/sites/1/sections/1/posts/1         | admin/posts         | update  | site_id: 1, section_id: 1, id: 1 |
      | DELETE | /admin/sites/1/sections/1/posts/1         | admin/posts         | destroy | site_id: 1, section_id: 1, id: 1 |
      | GET    | /admin/sites/1/sections/1/posts/1/edit    | admin/posts         | edit    | site_id: 1, section_id: 1, id: 1 |

      # adva-cart
      | POST   | /cart/items                               | cart_items          | create  |                                  |
      | PUT    | /cart/items/1                             | cart_items          | update  | id: 1                            |
      | DELETE | /cart/items/1                             | cart_items          | destroy | id: 1                            |
      | GET    | /cart                                     | cart                | show    |                                  |

      # adva-catalog
      | GET    | /sections/1/products                      | products            | index   | section_id: 1                    |
      | POST   | /sections/1/products                      | products            | create  | section_id: 1                    |
      | GET    | /sections/1/products/new                  | products            | new     | section_id: 1                    |
      | GET    | /sections/1/products/1                    | products            | show    | section_id: 1, id: 1             |
      | PUT    | /sections/1/products/1                    | products            | update  | section_id: 1, id: 1             |
      | DELETE | /sections/1/products/1                    | products            | destroy | section_id: 1, id: 1             |
      | GET    | /sections/1/products/1/edit               | products            | edit    | section_id: 1, id: 1             |
      | GET    | /admin/sites/1/sections/1/products        | admin/products      | index   | site_id: 1, section_id: 1        |
      | POST   | /admin/sites/1/sections/1/products        | admin/products      | create  | site_id: 1, section_id: 1        |
      | GET    | /admin/sites/1/sections/1/products/new    | admin/products      | new     | site_id: 1, section_id: 1        |
      | GET    | /admin/sites/1/sections/1/products/1      | admin/products      | show    | site_id: 1, section_id: 1, id: 1 |
      | PUT    | /admin/sites/1/sections/1/products/1      | admin/products      | update  | site_id: 1, section_id: 1, id: 1 |
      | DELETE | /admin/sites/1/sections/1/products/1      | admin/products      | destroy | site_id: 1, section_id: 1, id: 1 |
      | GET    | /admin/sites/1/sections/1/products/1/edit | admin/products      | edit    | site_id: 1, section_id: 1, id: 1 |

      # adva-core
      | POST   | /installations                            | installations       | create  |                                  |
      | GET    | /installations/new                        | installations       | new     |                                  |
      | GET    | /sections                                 | sections            | index   |                                  |
      | GET    | /sections/1                               | sections            | show    | id: 1                            |
      | GET    | /sections/1/article                       | articles            | show    | section_id: 1                    |

      | GET    | /admin/sites                              | admin/sites         | index   |                                  |
      | POST   | /admin/sites                              | admin/sites         | create  |                                  |
      | GET    | /admin/sites/new                          | admin/sites         | new     |                                  |
      | GET    | /admin/sites/1                            | admin/sites         | show    | id: 1                            |
      | PUT    | /admin/sites/1                            | admin/sites         | update  | id: 1                            |
      | DELETE | /admin/sites/1                            | admin/sites         | destroy | id: 1                            |
      | GET    | /admin/sites/1/edit                       | admin/sites         | edit    | id: 1                            |

      | GET    | /admin/sites/1/sections                   | admin/sections      | index   | site_id: 1                       |
      | POST   | /admin/sites/1/sections                   | admin/sections      | create  | site_id: 1                       |
      | GET    | /admin/sites/1/sections/new               | admin/sections      | new     | site_id: 1                       |
      | GET    | /admin/sites/1/sections/1                 | admin/sections      | show    | site_id: 1, id: 1                |
      | PUT    | /admin/sites/1/sections/1                 | admin/sections      | update  | site_id: 1, id: 1                |
      | DELETE | /admin/sites/1/sections/1                 | admin/sections      | destroy | site_id: 1, id: 1                |
      | GET    | /admin/sites/1/sections/1/edit            | admin/sections      | edit    | site_id: 1, id: 1                |

      | GET    | /admin/sites/1/sections/1/article         | admin/articles      | show    | site_id: 1, section_id: 1        |
      | POST   | /admin/sites/1/sections/1/article         | admin/articles      | create  | site_id: 1, section_id: 1        |
      | GET    | /admin/sites/1/sections/1/article/new     | admin/articles      | new     | site_id: 1, section_id: 1        |
      | PUT    | /admin/sites/1/sections/1/article         | admin/articles      | update  | site_id: 1, section_id: 1        |
      | DELETE | /admin/sites/1/sections/1/article         | admin/articles      | destroy | site_id: 1, section_id: 1        |
      | GET    | /admin/sites/1/sections/1/article/edit    | admin/articles      | edit    | site_id: 1, section_id: 1        |

      # adva-user
      | POST   | /users                                    | admin/registrations | create  |  |
      | PUT    | /users                                    | admin/registrations | update  |  |
      | DELETE | /users                                    | admin/registrations | destroy |  |
      | GET    | /users/sign_up                            | admin/registrations | new     |  |
      | GET    | /users/edit                               | admin/registrations | edit    |  |
