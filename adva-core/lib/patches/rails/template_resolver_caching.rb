# Gem.patching('rails', '3.0.0.rc') do
#   require 'action_view/template/resolver'
#   ActionView::Resolver.class_eval do
#     def caching?
#       # @caching ||= !defined?(Rails.application) || Rails.application.config.cache_classes
#       @caching ||= !defined?(Rails.application) || Rails.application.nil? || Rails.application.config.cache_classes
#     end
#   end
# end