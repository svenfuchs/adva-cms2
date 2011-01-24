require 'inherited_resources'
require 'inherited_resources/helpers'

class BaseController < InheritedResources::Base
  begin_of_association_chain :site
  tracks :resource, :resources, :collection, :site => %w(.title .name .sections)

  layout 'default'
  helper_method :site

  mattr_accessor :sortable
  self.sortable = []

  class << self
    def responder
      Adva::Responder
    end

    def sortable?(name)
      self.sortable.include?(name.to_sym)
    end
  end

  def site
    @site ||= Site.by_host(request.host_with_port)
  end

  def collection
    params[:order].present? ? sort(super, params[:order]) : super
  end

  protected

    def sort(collection, order)
      if !self.class.sortable?(order)
        collection
      elsif collection.respond_to?(order)
        collection.send(order)
      else
        collection.order(collection.arel_table[order.to_sym])
      end
    end
end

# ActiveRecord::Base.class_eval do
#   mattr_reader :sortable
#   self.sortable = []
#
#   class << self
#     def sortable_by?(name)
#       sortable.include?(name)
#     end
#
#     def sort_by(name)
#       sortable_by?(name) && respond_to?(name) : send(name) : self
#     end
#   end
# end
