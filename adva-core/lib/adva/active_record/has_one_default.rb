# Extends has_one associations to allow for a :default option.
#
# This will make the page.article association always build a default article
# unless an article is already set or persisted.
#
#    class Page < ActiveRecord::Base
#      has_one :article, :default => :build_default_article
#
#      def build_default_article
#        build_article(:title => 'default title', :body => 'default body')
#      end
#    end
#
# Note that we also include a default scope that includes the associated record
# to avoid n+1 queries.

module ActiveRecord
  module Associations
    module HasOneDefault
      def has_one(association_id, options = {})
        default = options.delete(:default)
        super
        has_one_default(association_id, default) if default
      end

      def has_one_default(association_id, default)
        default_scope includes(association_id) rescue nil # would raise during migrations. how to remove the rescue clause?
        validates_presence_of association_id

        define_method(:"#{association_id}_with_default") do
          send(:"#{association_id}_without_default") || send(:"#{association_id}=", send(default))
        end
        alias_method_chain association_id, :default
      end

      ActiveRecord::Base.extend(self)
    end
  end
end

