Feature: Managing pages

  Background:
    Given a site with the following sections:
      | type | name    | body         |
      | Page | Home    | Home body    |
      | Page | Contact | Contact body |
    And I am signed in with "admin@admin.org" and "admin!"
    And I am on the admin sections page

  Scenario: Listing pages as sections
    Then the title should be "Sections: Index"
    Then I should see a sections list
     And I should see "Home"
     And I should see "Contact"

  Scenario: Viewing a page on the website from the admin sections list
    When I follow "View" within the "Contact" row
    Then I should see "Contact"
     And I should see "Contact body"

  Scenario: Viewing a page on the website from the admin section page
    When I follow "Contact"
     And I follow "Website"
    Then I should see "Contact"
     And I should see "Contact body"

  Scenario Outline: Creating a page
    When I follow "New Section"
    Then the title should be "Pages: New"
     And I should see a section type form
     And the "Page" radio button should be checked
     And I should see a new page form
    When I fill in the following:
      | name | <name> |
      | body | <body> |
     And I press "Create page"
    Then I should see "<message>"
     And I should see a page form
     And I should see "<name>"
     And I should see "<body>"
    Examples:
      | name     | body     | message                   |
      | New name | New body | Page successfully created |
      | New name |          | Page successfully created |
      |          | New body | Page could not be created |

  Scenario Outline: Updating a page
    When I follow "Contact"
    Then the title should be "Pages: Show"
    Then I should see an edit page form
    When I fill in the following:
      | name | <name> |
      | body | <body> |
     And I press "Update page"
    Then I should see "<message>"
     And I should see an edit page form
     And I should see "<name>"
     And I should see "<body>"
    Examples:
      | name         | body         | message                   |
      | Updated name | Updated body | Page successfully updated |
      | Updated name |              | Page successfully updated |
      |              | Updated body | Page could not be updated |

  Scenario: Deleting a page from the sections list
    When I follow "Delete" within the "Home" row
    Then the title should be "Sections: Index"
     And I should see "Page successfully deleted"
     And I should not see "Home"
    When I follow "Delete" within the "Contact" row
    Then the title should be "Pages: Show"
     And I should see "Page could not be deleted"
     And I should see "Contact"

  Scenario: Deleting a page from the section page
    When I follow "Contact"
    When I follow "Delete"
    Then the title should be "Sections: Index"
     And I should see "Page successfully deleted"
     And I should not see "Contact"
