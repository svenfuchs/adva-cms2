Feature: Reset Password
  In order to get access to the page even if I forgot my password
  As a clumpsy user
  I want to reset my password

  Background:
    Given a site with the following sections:
       | type | name |
       | Page | Home |
      And the following users:
       | email              |
       | jarjar@example.com |
      And I am on the sign in page

  Scenario: Resetting a password
     When I follow "Forgot password"
      And I fill in "Email" with "jarjar@example.com"
      And I press "Send instructions"
     Then I should see "mail"
      And "jarjar@example.com" should receive an email

     When I open the email
     Then I should see "password" in the email body
      And I follow "Change my password" in the email
      And I fill in the following:
        | Password              | verysecret |
        | Password confirmation | verysecret |
      And I press "Change password"
     Then I should see "Your password was changed successfully. You are now signed in."
