# TODO for sven
# Feature: Tagging pages for cache invalidation
#
#   Scenario: Cache tagging pages
#     Given a site with the following sections:
#       | id |  type | name    |
#       | 1  |  Page | Home    |
#       | 2  |  Page | FAQ     |
#     When I go to /
#      And I go to /faq
#     Then the following urls should be tagged:
#       | url  | tags                 |
#       | /    | site-1:title, page-1 |
#       | /faq | site-1:title, page-2 |
#
#   Scenario: Cache tagging a blog and posts
#     Given a site with the following sections:
#       | id |  type | name    |
#       | 1  |  Blog | Blog    |
#     And the following posts:
#       | id |  section | title       | created_at |
#       | 1  |  Blog    | First post  | 2010-01-01   |
#       | 2  |  Blog    | Second post | 2010-01-02   |
#     When I go to /
#      And I go to /2010/01/01/first-post
#      And I go to /2010/01/02/second-post
#     Then the following urls should be tagged:
#       | url                     | tags                                 |
#       | /                       | site-1:title, blog-1, post-1, post-2 |
#       | /2010/01/01/first-post  | site-1:title, blog-1, post-1         |
#       | /2010/01/02/second-post | site-1:title, blog-1, post-2         |