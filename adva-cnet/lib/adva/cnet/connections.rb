module Adva
  class Cnet
    module Connections
      class Origin < ActiveRecord::Base
        establish_connection('cnet_origin')
      end
    
      class Import < ActiveRecord::Base
        establish_connection('cnet_import')
      end
    
      class Tmp < ActiveRecord::Base
        establish_connection('cnet_tmp')
      end
      
      class << self
        def origin
          @origin ||= Connection.new(Origin.connection)
        end
      
        def import
          @import ||= Connection.new(Import.connection, :with_link => 'cnet_origin')
        end
      
        def tmp
          @tmp ||= Connection.new(Tmp.connection)
        end
      end
    end
  end
end