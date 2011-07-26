require File.expand_path('../adva-core/lib/bundler/repository', __FILE__)

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

# TODO: remove this requirement when rack-mount does not break the routing filter
gem 'rack-mount', '0.6.14'

group :test do
  gem 'sqlite3-ruby', '1.2.5'
  gem "capybara", "~> 0.4.1.1"
  gem 'cucumber', '~> 0.10.2'
  gem 'cucumber-rails', '~> 0.4.1'
  gem 'thor'
  gem 'mocha'
  gem 'fakefs', :require => 'fakefs/safe'
  gem 'test_declarative'
  gem 'database_cleaner', ' ~> 0.6.7'
  gem 'launchy'
  gem 'factory_girl', '1.3.2'
  gem 'email_spec'
  gem 'pickle'
end

group :development, :test do
  # gem 'ruby-debug'
  # gem 'linecache', '0.43'

  platforms :mri_18 do
    # required as linecache uses it but does not have it as a dep
    gem "require_relative", "~> 1.0.1"
    gem 'ruby-debug'
  end

  # sadly ruby-debug19 (linecache19) doesn't
  # work with ruby-head, but we don't use this in
  # development so this should cover us just in case
  unless RUBY_VERSION == '1.9.3'
    gem 'ruby-debug19', :platforms => :mri_19
  end
end
