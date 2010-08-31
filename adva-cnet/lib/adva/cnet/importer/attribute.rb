# TODO
# - respect sort_order
# - optimize
# - multiple locales

module Adva
  class Cnet
    module Importer
      class Attribute < Base
        class Row < Base::Row
          ATTR_GROUP_NAMES = {
            'mspec' => 'Technische Spezifikationen',
            'espec' => 'Erweiterte Spezifikationen'
          }

          include ::Attributes

          attr_reader :key_attributes, :parent_attributes, :value_attributes,
                      :ext_value_id, :ext_key_id, :ext_parent_id, :ext_group_id, :ext_product_id

          def initialize(attributes)
            super
            @ext_value_id   = attributes['ext_value_id']
            ext_tokens      = ext_value_id.split('-')
            @ext_key_id     = ext_tokens[0, 3].join('-')
            @ext_parent_id  = ext_tokens[0, 2].join('-')
            @ext_group_id   = ext_tokens[0, 1].join('-')
            @ext_product_id = ext_tokens[3, 1].join

            @key_attributes    = { :name => attributes['key_name'], :locale => attributes['locale'] }
            @parent_attributes = { :name => attributes['section_name'], :locale => attributes['locale'] }
            @value_attributes  = { :display_value => attributes['display_value'], :locale => attributes['locale'] }
          end

          def import
            key.update_attributes!(key_attributes)
            key.parent.update_attributes!(parent_attributes) if espec?
            value.update_attributes!(value_attributes)
          end

          protected
          
            def espec?
              @espec ||= ext_group_id.start_with?('espec')
            end

            def group
              @grp ||= Key.find_by_ext_key_id(ext_group_id) ||
                       Key.create!(:ext_key_id => ext_group_id, :name => ATTR_GROUP_NAMES[ext_group_id], :locale => attributes['locale'])
            end

            def parent
              @par ||= Key.find_by_ext_key_id(ext_parent_id) ||
                       Key.create!(:ext_key_id => ext_parent_id, :parent_id => group.id)
            end

            def key
              @key ||= Key.find_by_ext_key_id(ext_key_id) ||
                       Key.create!(:ext_key_id => ext_key_id, :parent_id => (espec? ? parent : group).id)
            end

            def value
              @val ||= Value.find_by_ext_value_id(ext_value_id) ||
                       Value.create!(:key => key, :ext_value_id => ext_value_id, :ext_product_id => ext_product_id)
            end
        end
      end
    end
  end
end