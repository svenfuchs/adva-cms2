Feature: Running the import task

  Scenario: An empty import directory
    Given an empty import directory "import"
    When I run the import task
    Then there should be an account
     And there should be a site named "import"
     And there should be a page named "Home"

  Scenario: An import directory with a site source file
    Given an empty import directory "ruby-i18n.org"
     And a source file "site.yml" with the following values:
      | host  | ruby-i18n.org   |
      | name  | Ruby I18n       |
      | title | Ruby I18n title |
    When I run the import task
    Then there should be an account
     And there should be a site with the following attributes:
      | host  | ruby-i18n.org   |
      | name  | Ruby I18n       |
      | title | Ruby I18n title |
     And there should be a page named "Home"

  Scenario: An import directory with a single index page source file
    Given an empty import directory "import"
     And a source file "index.yml" with the following values:
      | name | Home |
    When I run the import task
    Then there should be a page with the following attributes:
      | name | Home |

  Scenario: An import directory with a bunch of page source files
    Given an empty import directory "import"
     And the following source files:
      | name | file        |
      | Home | index.yml   |
      | Foo  | foo.yml     |
      | Bar  | foo/bar.yml |
    When I run the import task
    Then there should be pages with the following attributes:
      | name | path    |
      | Home | home    |
      | Foo  | foo     |
      | Bar  | foo/bar |

  Scenario: An import directory with a single nested page source file
    Given an empty import directory "import"
     And a source file "foo/bar/baz.yml" with the following values:
      | name | Baz |
    When I run the import task
    Then there should be pages with the following attributes:
      | name | path        |
      | Foo  | foo         |
      | Bar  | foo/bar     |
      | Baz  | foo/bar/baz |

  Scenario: An import directory with blog post source files
    Given an empty import directory "import"
     And the following source files:
      | title | body     | file               |
      | Foo   | Foo body | 2010-1-1-foo.yml   |
      | Bar   | Bar body | 2010-10-10-bar.yml |
      | Baz   | Baz body | 2010/1/1/baz.yml   |
      | Buz   | Buz body | 2010/10/10/buz.yml |
    When I run the import task
    Then there should be a blog named "Home"
     And that blog should have posts with the following attributes:
      | title | body     | created_at |
      | Foo   | Foo body | 2010-01-01 |
      | Bar   | Bar body | 2010-10-10 |
      | Baz   | Baz body | 2010-01-01 |
      | Buz   | Buz body | 2010-10-10 |

  Scenario: An import directory with a root blog source file and a blog post source file
    Given an empty import directory "import"
     And the following source files:
      | name | title | body     | file             |
      | Blog |       |          | index.yml        |
      |      | Foo   | Foo body | 2010-1-1-foo.yml |
    When I run the import task
    Then there should be a blog named "Blog"
     And there should be a post with the following attributes:
      | title      | Foo        |
      | body       | Foo body   |
      | created_at | 2010-01-01 |

