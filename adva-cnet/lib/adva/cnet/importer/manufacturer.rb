module Adva
  class Cnet
    module Importer
      class Manufacturer < Base
        class Row < Base::Row
          def import
            manufacturer.update_attributes!(attributes.except('ext_manufacturer_id'))
          end

          protected
            def manufacturer
              @manufacturer ||= ::Cnet::Manufacturer.find_or_create_by_ext_manufacturer_id(attributes['ext_manufacturer_id'])
            end
        end
      end
    end
  end
end