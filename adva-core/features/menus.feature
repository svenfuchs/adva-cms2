Feature: Menus
  Scenario: Admin Sites
    Given I am signed in with "admin@admin.org" and "admin"
    And I am on the admin sites page
    Then the menu should contain the following items:
      | text     | url                       | active |
      | Sites    | /admin/sites              | yes    |

  Scenario: Admin Site
    Given I am signed in with "admin@admin.org" and "admin"
    And I am on the admin dashboard page
    Then the menu should contain the following items:
      | text     | url                       | active | menu        |
      | Sites    | /admin/sites              |        | #top .left  |
      | Overview | /admin/sites/1            | yes    | #top .left  |
      | Sections | /admin/sites/1/sections   |        | #top .left  |
      | Home     | /admin/sites/1/pages/1    |        | #top .left  |
      | Settings | /admin/sites/1/edit       |        | #top .right |

  Scenario: Admin Sections
    Given I am signed in with "admin@admin.org" and "admin"
    And I am on the admin site sections page
    Then the menu should contain the following items:
      | text     | url                         | active | menu            |
      | Sites    | /admin/sites                |        | #top .left      |
      | Overview | /admin/sites/1              |        | #top .left  |
      | Sections | /admin/sites/1/sections     | yes    | #top .left      |
      | Home     | /admin/sites/1/pages/1      |        | #top .left      |
      | Settings | /admin/sites/1/edit         |        | #top .right     |
      | Sections |                             |        | #actions .left  |
      | New      | /admin/sites/1/sections/new |        | #actions .right |
      | Reorder  | /admin/sites/1/sections     |        | #actions .right |

  Scenario: Admin Pages
    Given I am signed in with "admin@admin.org" and "admin"
    And I am on the admin "Home" section page
    Then the menu should contain the following items:
      | text     | url                         | active | menu            |
      | Sites    | /admin/sites                |        | #top .left      |
      | Overview | /admin/sites/1              |        | #top .left  |
      | Sections | /admin/sites/1/sections     | yes    | #top .left      |
      | Home     | /admin/sites/1/pages/1      | yes    | #top .left      |
      | Settings | /admin/sites/1/edit         |        | #top .right     |
      | Home:    |                             |        | #actions .left  |
      | Page     | /admin/sites/1/pages/1      | yes    | #actions .left  |
      | Settings | /admin/sites/1/pages/1/edit |        | #actions .left  |
      | View     | http://www.example.com/     |        | #actions .right |
      | Delete   | /admin/sites/1/pages/1      |        | #actions .right |
