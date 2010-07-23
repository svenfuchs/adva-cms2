module Adva
  module Preferable
    def self.included(base)
      class_name = base.name.demodulize.underscore
      base.class_eval <<-rb
        validates_uniqueness_of :preferred, :scope => [ :#{class_name}able_id, :#{class_name}able_type ],
          :if => :validate_preferred?

        before_validation :set_as_unique_preferred
        after_create :set_as_preferred

        protected
          # Allow preferred validation, only if the current #{class_name} is set as preferred.
          # Since #{class_name}able can have only one preferred #{class_name}, but multiple non-preferred.
          def validate_preferred?
            !!preferred
          end

          # If the current #{class_name} is the only belonging to #{class_name}able it should be set as preferred.
          def set_as_preferred
            update_attribute 'preferred', true unless #{class_name}able.#{class_name.pluralize}.many?
          end

          # If the current #{class_name} is set as preferred, all the others belonging
          # to #{class_name}able should be set as non-preferred.
          def set_as_unique_preferred
            if preferred
              self.class.update_all("preferred = 'f'",
                ["#{class_name}able_id = ? AND #{class_name}able_type = ? AND id NOT IN(?)",
                  #{class_name}able.id, #{class_name}able.class.name, id.to_i]) # when new record id.to_i == 0, otherwise it returns the id value
            end
          end
      rb
    end

    module Associations
      def self.included(base)
        base.class_eval <<-rb
          has_many :addresses, :as => :addressable, :dependent => :destroy,
            :extend => Preferable::AssociationExtension, :after_remove => :set_preferred

          has_many :emails, :as => :email_infoable, :dependent => :destroy,
            :extend => Preferable::AssociationExtension, :after_remove => :set_preferred, :class_name => 'EmailInfo'

          has_many :telephones, :as => :telephoneable, :dependent => :destroy,
            :extend => Preferable::AssociationExtension, :after_remove => :set_preferred

          alias_method :email_infos, :emails

          def set_preferred(record)
            return unless record.preferred

            if (record = self.send(record.class.name.tableize, true).first)
              record.update_attribute 'preferred', true
            end
          end
          private :set_preferred
        rb
      end
    end

    module AssociationExtension
      def preferred
        self.find(:first, :conditions => { :preferred => true })
      end
    end
  end
end