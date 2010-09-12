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

            before_filter :internal_redirect_to_concretion,
              options.merge(:if => lambda { |c| c.instance_of?(Admin::SectionsController) })
          end
        end

        def abstract_actions?
          included_modules.include?(InstanceMethods)
        end
      end

      module InstanceMethods
        # redirects requests to an abstract controller action (e.g. sections#show)
        # to the concrete controller (e.g. pages#show)
        def internal_redirect_to_concretion
          params[instance_name] = params.delete(base_controller_name.singularize)
          internal_redirect_to("#{concrete_controller_path}##{params[:action]}")
        end

        # redirects the view lookup to section type paths for all actions except
        # :index. e.g. if the resource is a page then the show view will be looked
        # up in views/admin/pages, not view/admin/sections
        def _prefix
          concrete_controller_path
        end

        def concrete_controller_path
          "#{controller_namespace}/#{concrete_action? ? base_controller_name : collection_name}"
        end
        
        def concrete_action?
          Array(abstract_action_options[:except]).include?(params[:action])
        end

        def base_controller_name
          @base_name ||= begin
            base = self.class
            base = base.superclass until base.superclass.controller_name == 'base'
            base.controller_name
          end
        end

        def controller_namespace
          @controller_namespace ||= controller_path.split('/')[0..-2].join('/')
        end
      end

      ActionController::Base.extend(ActMacro)
    end
  end
end

