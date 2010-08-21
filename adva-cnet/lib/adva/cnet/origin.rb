ActiveRecord::Base.configurations['cnet_origin'] ||= { 'adapter' => 'sqlite3', 'database' => ':memory:' }

module Adva
  class Cnet
    class Origin < ActiveRecord::Base
      autoload :Database, 'adva/cnet/origin/database'
      autoload :Fixtures, 'adva/cnet/origin/fixtures'
      autoload :Prepare,  'adva/cnet/origin/prepare'
      autoload :Schema,   'adva/cnet/origin/schema'
      autoload :Source,   'adva/cnet/origin/source'
      
      establish_connection('cnet_origin') # #{Rails.env.downcase}
    end
  end
end