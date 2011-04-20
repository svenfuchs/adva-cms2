Feature: Registration
  Background:
    Given a site

  Scenario: Registering a new user account for a site
    Given I am on the new registration page
     Then I should see a user new form
     When I fill in "Email" with "john@doe.com"
      And I fill in "Password" with "password"
      And I fill in "Password confirmation" with "password"
      And I press "Sign up"
     Then I should be on the sign in page
      And I should see "You have signed up successfully. However, we could not sign you in because your account is unconfirmed. A confirmation was sent to your e-mail."
      And the following emails should have been sent:
        | to              | subject                   | body                 |
        | john@doe.com    | Confirmation instructions | confirm your account |
     When I visit the url from the email to john@doe.com
     Then I should see "Your account was successfully confirmed. You are now signed in."
     Then I should be signed in
