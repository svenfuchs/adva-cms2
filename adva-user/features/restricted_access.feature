Feature: restricted access
  In order to protect my site from changed by random users
  As a site owner
  I want access to the backend restricted to admins

  Background:
    Given a site exists with name: "My Site"

  Scenario: anonymous visitor may not visit backend
     When I go to the admin sections page
     Then I should not be on the admin sections page
      And I should see flash message "You need to sign in or sign up before continuing."

  Scenario: user may not visit backend
    Given I am signed in as user
     When I go to the admin sections page
     Then I should not be on the admin sections page
      And show me the page
      And I should see flash message "Access Denied"

  Scenario: admin may visit backend
    Given I am signed in as admin
     When I go to the admin sections page
     Then I should be on the admin sections page
      And I should see "My Site" within the main menu
