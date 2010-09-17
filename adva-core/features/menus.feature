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
      | adva-cms |                           |        | #top .main  |
      | adva-cms | /admin/sites/1            | yes    | #top .main  |
      | Sections | /admin/sites/1/sections   |        | #top .main  |
      | Home     | /admin/sites/1/pages/1    |        | #top .main  |
      | Settings | /admin/sites/1/edit       |        | #top .right |

  Scenario: Admin Sections
    Given I am signed in with "admin@admin.org" and "admin"
    And I am on the admin site sections page
    Then the menu should contain the following items:
      | text     | url                         | active | menu            |
      | adva-cms |                             |        | #top .main  |
      | adva-cms | /admin/sites/1              |        | #top .main  |
      | Sections | /admin/sites/1/sections     | yes    | #top .main      |
      | Home     | /admin/sites/1/pages/1      |        | #top .main      |
      | Settings | /admin/sites/1/edit         |        | #top .right     |
      | Sections | /admin/sites/1/sections     | yes    | #actions .main  |
      | New      | /admin/sites/1/sections/new |        | #actions .right |
      | Reorder  | /admin/sites/1/sections     |        | #actions .right |

  Scenario: Admin Pages
    Given I am signed in with "admin@admin.org" and "admin"
    And I am on the admin "Home" section page
    Then the menu should contain the following items:
      | text     | url                         | active | menu            |
      | adva-cms |                             |        | #top .main  |
      | adva-cms | /admin/sites/1              |        | #top .main  |
      | Sections | /admin/sites/1/sections     | yes    | #top .main      |
      | Home     | /admin/sites/1/pages/1      | yes    | #top .main      |
      | Settings | /admin/sites/1/edit         |        | #top .right     |
      | Home:    |                             |        | #actions .main  |
      | Page     | /admin/sites/1/pages/1      | yes    | #actions .main  |
      | View     | http://www.example.com/     |        | #actions .right |
      | Delete   | /admin/sites/1/pages/1      |        | #actions .right |
