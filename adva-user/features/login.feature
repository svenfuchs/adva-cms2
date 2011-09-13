Feature: Signing in

  Background:
    Given a site with the following sections:
     | type | name |
     | Page | Home |

  Scenario: Signing with valid email and password
    Given I sign in as admin
    Then I should be signed in

  Scenario: Signing with invalid email and password
    Given I sign in with "admin@admin.org" and "wrong password"
    Then I should see "Invalid email or password"
