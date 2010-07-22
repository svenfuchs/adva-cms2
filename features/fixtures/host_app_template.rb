# Cucumber wants to load this as a step definition file?
if respond_to?(:remove_file)
  # would need to patch Thor actions.rb #183 instance_eval(..., path, 0)
  # gem_root = File.expand_path('../../..', __FILE__)
  gem_root = ENV['GEM_ROOT']

  gem 'devise', '1.1.rc2'

  gem 'adva-core',      :path => "#{gem_root}/adva-core"
  gem 'adva-blog',      :path => "#{gem_root}/adva-blog"
  gem "adva-cart",      :path => "#{gem_root}/adva-cart"
  gem "adva-contacts",  :path => "#{gem_root}/adva-contacts"
  gem 'adva-catalog',   :path => "#{gem_root}/adva-catalog"
  gem 'adva-user',      :path => "#{gem_root}/adva-user"

  # gem 'silence_log_tailer'

  remove_file 'public/index.html'
end