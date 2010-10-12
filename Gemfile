require File.expand_path('../lib/bundler/repository', __FILE__)

source :rubygems

workspace '. ~/.projects ~/projects ~/Development/{projects,work} ~/.repositories'
adva_cms = repository('adva-cms2', :source => :local)

adva_cms.gem  'adva-blog'
adva_cms.gem  'adva-cache'
adva_cms.gem  'adva-core'
adva_cms.gem  'adva-markup'
adva_cms.gem  'adva-static'
adva_cms.gem  'adva-user'

gem 'rails', '3.0.0'
gem 'has_many_polymorphs', :git => 'git://github.com/kronn/has_many_polymorphs.git', :ref => '36f15d2'
gem 'carrierwave', :git => 'git://github.com/jnicklas/carrierwave.git', :ref => '60314c375783'

# gem 'simple_nested_set', :path => '~/Development/projects/simple_nested_set'
# gem 'minimal', :path => '~/Development/projects/minimal'
# gem 'reference_tracking', :path => '~/Development/projects/reference_tracking'
# gem 'rack-cache-purge', :path => '~/Development/projects/rack-cache-purge'
# gem 'rack-cache-tags',  :path => '~/Development/projects/rack-cache-tags'
# gem 'inherited_resources_helpers', :path => '~/Development/projects/inherited_resources_helpers'

group :test do
  gem 'sqlite3-ruby', '1.2.5'
  gem 'cucumber', '0.9.0'
  gem 'cucumber-rails', '0.3.2'
  gem 'webrat', '0.7.0' # '0.7.2.beta.1'
  gem 'thor'
  gem 'ruby-debug'
  gem 'mocha'
  gem 'fakefs', :require => 'fakefs/safe'
  gem 'test_declarative'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'factory_girl', '1.3.2'
end
