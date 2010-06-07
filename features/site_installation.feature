Feature: Installing a Site, creating a section with an article
  Background: no site
  
  @work
  Scenario: Installing a Site
    Given I go to the homepage
    Then I should see a new site form
    
