require File.expand_path('../../test_helper', __FILE__)

require 'yaml'
require 'ruby-debug'

Site.has_many :blogs

require Adva::Static.root.join('lib/testing/test_helper')