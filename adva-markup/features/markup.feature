Feature: Content markup filtering
  Background:
    Given a site with a blog named "Blog"
     And I am signed in with "admin@admin.org" and "admin!"
     And I am on the admin "Blog" section page

  Scenario: Writing a blog post in textile
    When I follow "New"
     And I select "Textile" from "Filter"
     And I fill in "Title" with "Blog Post"
     And I fill in "Body" with "**bold**"
     And I press "Create"
    Then "Body" should be filled in with "**bold**"
     And "Textile" should be selected as "Filter"
    When I follow "Website"
    Then I should see "bold" formatted as a "b" tag

  Scenario: Setting the default filter type for a Blog
    When I follow "Settings" within "#actions"
     And I select "Textile" from "Default filter"
     And I press "Update"
    Then "Textile" should be selected as "Default filter"
    When I follow "New Post"
    Then "Textile" should be selected as "Filter"
