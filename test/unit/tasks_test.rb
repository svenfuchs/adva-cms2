require File.expand_path('../../test_helper', __FILE__)
require 'tasks/core'

class TasksTest < Test::Unit::TestCase
  test 'adva:core:install copies all migrations from all adva engines' do

    Adva.engines.each do |engine|
      filenames = %W(#{engine.root}/migration_1 #{engine.root}/migration_2)
      Dir.stubs(:[]).with(engine.root.join('db/migrate/*')).returns(filenames)
    
      filenames.each do |source|
        FileUtils.expects(:cp).with(source, source.gsub(engine.root.to_s, '.'))
      end
    end
    
    Adva::Core::Tasks.new.install
  end
end