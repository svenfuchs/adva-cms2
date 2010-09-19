require 'action_controller'

# abstract_actions makes a base controller transparently use a concrete controller
# for certain actions. E.g. with an sti base model like Section and concrete model
# like Page if the route points to the SectionsController it still will use a
# PagesController if the current resource is a Page.

module Adva
  module Controller
    module AbstractActions
      module ActMacro
        def abstract_actions(options = {})
          unless abstract_actions?
            include InternalRedirect
            include InstanceMethods

            class_inheritable_accessor :abstract_action_options
            self.abstract_action_options = options.reverse_merge(:except => [])

            before_filter :internal_redirect
          end
        end

        def abstract_actions?
          included_modules.include?(InstanceMethods)
        end
      end

      module InstanceMethods
        def internal_redirect
          if redirect_to_concretion?
            internal_redirect_to_concretion
          elsif redirect_to_abstraction?
            internal_redirect_to_abstraction
          end
        end

        protected

          def redirect_to_abstraction?
            concrete_controller? && !concrete_action?
          end

          def redirect_to_concretion?
            !concrete_controller? && concrete_action?
          end

          def internal_redirect_to_abstraction
            params[abstract_instance_name] = params.delete(instance_name)
            internal_redirect_to("#{abstract_controller_class.controller_path}##{params[:action]}")
          end

          def internal_redirect_to_concretion
            params[instance_name] = params.delete(abstract_instance_name)
            internal_redirect_to("#{controller_namespace}/#{collection_name}##{params[:action]}")
          end

          def concrete_controller?
            !self.instance_of?(abstract_controller_class)
          end

          def concrete_action?
            !Array(abstract_action_options[:except]).include?(params[:action].to_sym)
          end

          def abstract_controller_class
            @abstract_controller_class ||= begin
              abstract = self.class
              abstract = abstract.superclass until abstract.superclass.controller_name == 'base'
              abstract
            end
          end

          def abstract_instance_name
            @abstract_instance_name ||= abstract_controller_class.controller_name.singularize
          end

          def controller_namespace
            @controller_namespace ||= controller_path.split('/')[0..-2].join('/')
          end
      end

      ActionController::Base.extend(ActMacro)
    end
  end
end

