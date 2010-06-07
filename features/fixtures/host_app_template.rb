# Cucumber wants to load this as a step definition file?
if respond_to?(:remove_file)
  # would need to patch Thor actions.rb #183 instance_eval(..., path, 0)
  # gem_root = File.expand_path('../../..', __FILE__)
  gem_root = ENV['GEM_ROOT']

  gem 'adva-cms2', :path => gem_root, :require => 'adva/cms'

  remove_file "public/index.html"
end