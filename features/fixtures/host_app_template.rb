# Cucumber wants to load this as a step definition file?
if respond_to?(:remove_file)
  # would need to patch Thor actions.rb #183 instance_eval(..., path, 0)
  # gem_root = File.expand_path('../../..', __FILE__)
  gem_root = ENV['GEM_ROOT']

  gem 'devise'
  gem 'adva-core', :path => "#{gem_root}/adva-core"
  gem 'adva-user', :path => "#{gem_root}/adva-user"

  remove_file 'public/index.html'

  # for some weird reason this will get appended to the Rakefile twice
  
  append_file 'Rakefile', <<-rb.split("\n").map { |line| line.strip }.join("\n")
    namespace :adva do
      desc 'Install Adva CMS'
      task :install do
        require 'adva/core/tasks'
        require 'adva/user/tasks'

        Adva::Core::Tasks.new.install
        Adva::User::Tasks.new.install
      end
    end
  rb
end