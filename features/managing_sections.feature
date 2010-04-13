Feature: Managing Sections
  @wip
  Scenario: Creating a new page
  Given I am on the admin dashboard page
  When I follow "new section"
  Then I should see a create section form
  And I fill in "title" with "brand new section"
  And I select "section" from "type"
  And I choose "single article per page"
  And I press "create"
  Then I should see an update article form
  And I fill in "body" with "the brand new section's body"
  And I press "save"
  Then I should see an update article form
  And I follow "preview"
  Then I should see be on the "brand new section" page
