Feature: Installation

  Scenario: Installing a new site
    Given I go to the homepage
     Then I should see a new site form
     When I fill in "Name" with "Site 1"
      And I choose "Page"
      And I fill in "Section name" with "Home"
      And I press "Create"
     Then I should be on the site installation confirmation page
      And I should see "Success!"
      And I should see "Manage your new site"
     # TODO [user dependency] Then I should be on the admin site edit page

  Scenario: Trying to install a site for a port that already exist
    Given a site
     When I go to the site installation page
     Then I should see a new site form
      And I should see /Installation for .* is already complete/
