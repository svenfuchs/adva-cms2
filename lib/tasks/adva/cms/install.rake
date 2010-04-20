require 'tasks/adva/cms/install'

namespace :adva do
  namespace :cms do
    desc 'Install Adva CMS'
    task :install do
      Adva::Cms::Install.new.copy_migrations
    end
  end
end