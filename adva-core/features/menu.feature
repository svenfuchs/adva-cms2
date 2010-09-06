Feature: Routes
  Scenario: Routes
    Given I am signed in with "admin@admin.org" and "admin"
    And I am on the admin dashboard page
    Then the menu should contain the following items:
      | text     | url                       | active |
      | Sites    | /admin/sites              | yes    |
      | Sections | /admin/sites/1/sections   | yes    |
      | Home     | /admin/sites/1/pages/1    |        |
      | Settings | /admin/sites/1/edit       |        |
