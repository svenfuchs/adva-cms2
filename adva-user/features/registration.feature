Feature: Registration
  Background:
    Given a site

  Scenario: Registering a new user account for a site
    Given I am on the new registration page
     Then I should see a user new form
     When I fill in "Email" with "john-doe@example.com"
      And I fill in "Password" with "password"
      And I fill in "Password confirmation" with "password"
      And I press "Sign up"
     Then I should be on the sign in page
      And I should see "You have signed up successfully. However, we could not sign you in because your account is unconfirmed. A confirmation was sent to your e-mail."
      And "john-doe@example.com" should receive an email with subject "Confirmation instructions"
     When I open the email
     Then I should see "confirm your account" in the email body
     When I click the first link in the email
     Then I should see "Your account was successfully confirmed. You are now signed in."
      And I should be signed in
