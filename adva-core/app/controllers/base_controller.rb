require 'inherited_resources'
require 'inherited_resources/helpers'

class BaseController < InheritedResources::Base
  begin_of_association_chain :site
  tracks :resource, :resources, :collection, :site => %w(.title .name .sections)

  layout :layout
  helper_method :site

  mattr_accessor :sortable
  self.sortable = []

  class << self
    def responder
      Adva::Responder
    end

    def sortable?(order)
      !!sortable_direction(order)
    end

    def sortable_direction(order)
      self.sortable.assoc(order.to_sym).last rescue nil
    end
  end

  def site
    @site ||= Site.by_host(request.host_with_port)
  end

  def collection
    params[:order].present? ? sort(super, params[:order]) : super
  end

  protected

    def layout
      'default' unless params[:format] == 'atom'
    end

    def sort(collection, order)
      if !self.class.sortable?(order)
        collection
      elsif collection.respond_to?(order)
        collection.send(order)
      elsif collection.arel_table[order]
        collection.order(collection.arel_table[order].send(self.class.sortable_direction(order)))
      else
        collection
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
