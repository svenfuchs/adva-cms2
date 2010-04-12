require 'fileutils'

module HostApp
  HOST_APP_ROOT = '/tmp/host_app' unless defined? HOST_APP_ROOT
  ENGINE_ROOT   = File.expand_path('../../..', __FILE__) unless defined? ENGINE_ROOT

  def recreate_host_app
    FileUtils.rm_rf(HOST_APP_ROOT) if File.exist?(HOST_APP_ROOT)
    %x[ENGINE_ROOT='#{ENGINE_ROOT}' rails #{HOST_APP_ROOT} -m #{ENGINE_ROOT}/features/support/host_app_template.rb --quiet]
  end

  def load_host_app_environment
    in_host_app_root do
      load File.expand_path(File.join(HOST_APP_ROOT, 'config', 'environment.rb'))
    end
  end

  def execute_in_host_app_root(command)
    in_host_app_root { %x[#{command}] }
  end

  def migrate_host_app_db
    in_host_app_root { %x[rake db:migrate db:schema:dump db:test:clone_structure] }
  end

  def in_host_app_root(&block)
    Dir.chdir(HOST_APP_ROOT, &block)
  end
end