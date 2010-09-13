Feature: Registration
  Scenario: Registering a new user account for a site
    Given I am on the new registration page
     Then I should see a user new form
     When I fill in "Email" with "john@doe.com"
      And I fill in "Password" with "password"
      And I fill in "Password confirmation" with "password"
      And I press "Create User"
     Then I should be on the sign in page
      And the following emails should have been sent:
        | to              | subject                   | body                 |
        | john@doe.com    | Confirmation instructions | confirm your account |
     When I click on the link from the email to john@doe.com
     # TODO Then I should see a flash notice "foo bar"
     Then I should be signed in