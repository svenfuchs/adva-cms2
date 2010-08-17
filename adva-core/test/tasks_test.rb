# # TODO just doesn't work this way. use fake_fs instead.
#
# require File.expand_path('../test_helper', __FILE__)
# require 'action_controller'
# require 'adva/tasks/core'
#
# module AdvaCoreTests
#   class TasksTest < Test::Unit::TestCase
#     test 'adva:core:install copies all migrations from all adva engines' do
#
#       Adva.engines.each do |engine|
#         sources = %W(#{engine.root}/migration_1 #{engine.root}/migration_2)
#         Dir.stubs(:[]).with(engine.root.join('db/migrate/*')).returns(sources)
#
#         sources.each do |source|
#           FileUtils.expects(:cp).with(source, source.gsub(engine.root.to_s, '.'))
#         end
#       end
#
#       Adva::Install.new.perform
#     end
#   end
# end