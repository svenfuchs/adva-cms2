require File.expand_path('../../../features/env', __FILE__)


# thanks to http://oinopa.com/2011/02/05/want-a-faster-test-suite.html
module Devise
  module Encryptors
    class Plain < Base
      class << self
        def digest(password, *args)
          password
        end

        def salt(*args)
          ""
        end
      end
    end
  end
end
Devise.encryptor = :plain
