Feature: Installing a Site, creating a section with an article
  Background:
    Given no site or account

  Scenario: Installing a Site
    Given I go to the homepage
     Then I should see a new site form
     When I fill in "Name" with "Site 1"
      And I choose "Page"
      And I fill in "Section name" with "Home"
      And I press "Create"
     Then I should be on the site installation confirmation page
      And I should see "Success!"
     When I follow "Manage your new site"
     # TODO then I should be on the admin site edit page