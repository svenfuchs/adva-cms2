Feature: Routes
  Scenario: Routes
    Given the routes are loaded
    Then the following routes should be recognized:
      | method | path            | controller    | action  | params |

      | GET    | /users/sign_in  | session       | new     |        |
      | POST   | /users/sign_in  | session       | create  |        |
      | GET    | /users/sign_out | session       | destroy |        |

      | POST   | /users          | registrations | create  |        |
      | PUT    | /users          | registrations | update  |        |
      | DELETE | /users          | registrations | destroy |        |
      | GET    | /users/sign_up  | registrations | new     |        |
      | GET    | /users/edit     | registrations | edit    |        |
