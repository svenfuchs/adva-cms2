Feature: Routes
  Scenario: Routes
    Given the routes are loaded
    Then the following routes should be recognized:
      | method | path                                      | controller          | action  | params                                              |

      # adva-user
      | POST   | /users                                    | admin/registrations | create  |                                                     |
      | PUT    | /users                                    | admin/registrations | update  |                                                     |
      | DELETE | /users                                    | admin/registrations | destroy |                                                     |
      | GET    | /users/sign_up                            | admin/registrations | new     |                                                     |
      | GET    | /users/edit                               | admin/registrations | edit    |                                                     |
