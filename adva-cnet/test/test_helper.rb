require File.expand_path('../../../adva-core/test/test_helper', __FILE__)

$: << File.expand_path('../../../adva-cnet/lib', __FILE__)
require 'adva-cnet'

ActiveRecord::Base.configurations = { 'cnet_origin' => { :adapter => 'sqlite3', :database => ':memory:' } }

CNET_FIXTURES_PATH = File.expand_path('../fixtures', __FILE__)