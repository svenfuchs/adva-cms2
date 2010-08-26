require File.expand_path('../../../adva-core/test/test_helper', __FILE__)

$: << File.expand_path('../../../adva-cnet/lib', __FILE__)
require 'adva-cnet'

ActiveRecord::Base.configurations = { 'cnet_origin' => { :adapter => 'sqlite3', :database => ':memory:' } }

fixtures_path = File.expand_path('/tmp/adva-cnet-test/fixtures', __FILE__)
unless File.directory?("#{fixtures_path}/catalog")
  FileUtils.mkdir_p(fixtures_path)
  `unzip #{File.expand_path('../fixtures/download.zip', __FILE__)} -d #{fixtures_path}`
end
CNET_FIXTURES_PATH = fixtures_path

module CnetTestHelper
  class << self
    def set_db_paths!(test)
      db_names.each { |name| test.instance_variable_set(:"@#{name}_path", CnetTestHelper.db_path(test, name)) }
    end
    
    def set_db!(test)
      test.instance_variable_set(:@db, Adva::Cnet::Connection.new(test.main_path))

      Adva::Cnet::Sql.load(Adva::Cnet.normalize_path('origin.schema.sqlite3.sql'), db_path(test, 'origin'))
      Adva::Cnet::Sql.load(Adva::Cnet.normalize_path('origin.schema.sqlite3.sql'), db_path(test, 'full'))
      Adva::Cnet::Sql.load(Adva::Cnet.normalize_path('origin.schema.sqlite3.sql'), db_path(test, 'fixtures'))
      Adva::Cnet::Sql.load(Adva::Cnet.normalize_path('import.schema.sql'), db_path(test, 'import'))
    end
    
    def attach_dbs!(test)
      db_names.each { |name| test.db.attach_database(db_path(test, name), name) }
    end
    
    def delete_databases!(test)
      db_names.each { |name| FileUtils.rm(db_path(test, name)) rescue Errno::ENOENT }
    end
    
    def db_names
      %w(main origin full fixtures import)
    end
    
    def db_path(test, stage)
      db_dir.join("test.#{test.class.name.demodulize.gsub('Test', '').underscore}.#{stage}.sqlite3")
    end

    def db_dir
      Pathname.new('/tmp/adva-cnet-test/db').tap { |path| FileUtils.mkdir_p(path) }
    end
  end

  attr_reader :db

  db_names.each do |name|
    delegate name, :to => :db
    attr_reader :"#{name}_path"
  end
  
  def setup
    CnetTestHelper.delete_databases!(self)
    CnetTestHelper.set_db_paths!(self)
    CnetTestHelper.set_db!(self)
    CnetTestHelper.attach_dbs!(self)

    # super
  end

  def teardown
    db.close
    CnetTestHelper.delete_databases!(self)
    # super
  end
end