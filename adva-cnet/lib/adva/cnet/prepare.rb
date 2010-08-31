module Adva
  class Cnet
    class Prepare < ActiveRecord::Base
      autoload :Origin, 'adva/cnet/prepare/origin'
    end
  end
end