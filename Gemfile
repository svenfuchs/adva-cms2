require File.expand_path('../lib/bundler/repository', __FILE__)

source :rubygems

workspace '. ~/.projects ~/projects ~/Development/{projects,work} ~/.repositories'
adva_cms = repository('adva-cms2', :source => :local)

adva_cms.gem  'adva-core'
adva_cms.gem  'adva-blog'
adva_cms.gem  'adva-cache'
adva_cms.gem  'adva-categories'
adva_cms.gem  'adva-static'
adva_cms.gem  'adva-user'
adva_cms.gem  'adva-markup'

gem 'i18n', :git => 'git://github.com/svenfuchs/i18n.git', :ref => '0.5.0'

group :test do
  gem 'sqlite3-ruby', '1.2.5'
  gem 'cucumber', '0.9.4'
  gem 'cucumber-rails', '0.3.2'
  gem 'webrat', '0.7.2'
  gem 'thor'
  gem 'ruby-debug'
  gem 'mocha'
  gem 'fakefs', :require => 'fakefs/safe'
  gem 'test_declarative'
  gem 'database_cleaner', '0.5.2'
  gem 'launchy'
  gem 'factory_girl', '1.3.2'
end
