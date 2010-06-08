Feature: Routes
  Scenario: Routes
    Given the routes are loaded
    Then the following routes should be recognized:
      | method | path                | controller     | action  | id |
      | GET    | /installations/new  | installations  | new     |    |
      | POST   | /installations      | installations  | create  |    |
      | GET    | /sections/1         | sections       | show    | 1  |
      | GET    | /admin/sites        | admin/sites    | index   |    |
      | GET    | /admin/sites/1      | admin/sites    | show    | 1  |
      | GET    | /admin/sites/new    | admin/sites    | new     |    |
      | GET    | /admin/sites/1/edit | admin/sites    | edit    | 1  |
      | POST   | /admin/sites        | admin/sites    | create  |    |
      | PUT    | /admin/sites/1      | admin/sites    | update  | 1  |
      | DELETE | /admin/sites/1      | admin/sites    | destroy | 1  |

