Feature: Content markup filtering

  Scenario: Writing a blog post in textile
    Given a site
     And a blog named "Blog"
     And I am signed in with "admin@admin.org" and "admin"
     And I am on the admin "Blog" section page
    When I follow "New post"
     And I select "Textile" from "Filter"
     And I fill in "Title" with "Blog Post"
     And I fill in "Body" with "**bold**"
     And I press "Create"
    Then "Body" should be filled in with "**bold**"
     And "Textile" should be selected as "Filter"
    When I follow "Website"
    Then I should see "bold" formatted as a "b" tag

