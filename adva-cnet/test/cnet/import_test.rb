# require File.expand_path('../../test_helper', __FILE__)
#
# require 'adva/cnet/origin'
#
# module Tests
#   module Cnet
#     class ImportTest < Test::Unit::TestCase
#       attr_reader :origin, :import
#
#       def setup
#         @origin = Adva::Cnet::Origin::Database.new(':memory:')
#         @import = Adva::Cnet::Origin::Database.new(':memory:')
#         Adva::Cnet::Origin::Fixtures.load(nil, origin.connection)
#       end
#
#       test "importing products" do
#         origin = Adva::Cnet::Origin::Database.new(':memory:')
#         connection = origin.connection.instance_variable_get(:@connection)
#         connection.execute('attach database ":memory:" as foo')
#         connection.execute('create table foo.bar(x)')
#         connection.execute('insert into foo.bar values(1)')
#         connection.execute('insert into foo.bar values(2)')
#         # p origin.select_all('select count(*) from foo.bar')
#
# #
# # (rdb:1) p origin.connection.instance_variable_get(:@connection).database_list
# # [{"name"=>"main", 0=>"0", 1=>"main", 2=>"", "file"=>"", "seq"=>"0"},
# # {"name"=>"foo", 0=>"2", 1=>"foo", 2=>"/Volumes/Users/sven/Development/projects/adva_cms/adva-cms2/test.sqlite3",
# #  "file"=>"/Volumes/Users/sven/Development/projects/adva_cms/adva-cms2/test.sqlite3", "seq"=>"2"}]
#
#
#       end
#     end
#   end
# end