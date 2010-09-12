Feature: Routes
  Scenario: Routes
    Given the routes are loaded
    Then the following routes should be recognized:
      | method | path           | controller         | action  | params |

      | GET    | /user/sign_in  | user/sessions      | new     |        |
      | POST   | /user/sign_in  | user/sessions      | create  |        |
      | GET    | /user/sign_out | user/sessions      | destroy |        |

      | POST   | /user          | user/registrations | create  |        |
      | PUT    | /user          | user/registrations | update  |        |
      | DELETE | /user          | user/registrations | destroy |        |
      | GET    | /user/sign_up  | user/registrations | new     |        |
      | GET    | /user/edit     | user/registrations | edit    |        |
