module Adva
  class Cnet
    class Origin < ActiveRecord::Base
      autoload :Fixtures,   'adva/cnet/origin/fixtures'
      autoload :Prepare,    'adva/cnet/origin/prepare'
    end
  end
end