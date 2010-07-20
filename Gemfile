# this gemfile is only required for running the features/tests

source :rubygems

gem 'rails', '3.0.0.beta4'
gem 'adva-core',    :path => File.expand_path('../adva-core', __FILE__)
gem 'adva-blog',    :path => File.expand_path('../adva-blog', __FILE__)
gem 'adva-cart',    :path => File.expand_path('../adva-cart', __FILE__)
gem 'adva-catalog', :path => File.expand_path('../adva-catalog', __FILE__)
gem 'adva-user',    :path => File.expand_path('../adva-user', __FILE__)

group :test do
  gem 'sqlite3-ruby', '1.2.5'
  gem 'cucumber'
  gem 'cucumber-rails'
  gem 'webrat', '0.7.0'
  gem 'thor'
  gem 'ruby-debug'
  gem 'mocha'
  gem 'test_declarative'
  gem 'database_cleaner'
end