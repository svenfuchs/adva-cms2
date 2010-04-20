Feature: Routes
  Scenario: Routes
    Given the routes are loaded
    Then the following routes should be recognized:
      | method | path                     | controller       | action  | id |
      | GET    | /adva/admin/sites        | adva/admin/sites | index   |    |
      | GET    | /adva/admin/sites/1      | adva/admin/sites | show    | 1  |
      | GET    | /adva/admin/sites/new    | adva/admin/sites | new     |    |
      | GET    | /adva/admin/sites/1/edit | adva/admin/sites | edit    | 1  |
      | POST   | /adva/admin/sites        | adva/admin/sites | create  |    |
      | PUT    | /adva/admin/sites/1      | adva/admin/sites | update  | 1  |
      | DELETE | /adva/admin/sites/1      | adva/admin/sites | destroy | 1  |

