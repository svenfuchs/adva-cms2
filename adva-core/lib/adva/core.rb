require 'rails'
require 'rails/engine'
require 'active_support/slices'
require 'adva'

require 'simple_form'
require 'simple_slugs'
require 'simple_nested_set'
require 'simple_table'
require 'simple_slugs'
require 'has_many_polymorphs'
require 'minimal'
require 'i18n/missing_translations'
require 'silence_log_tailer'

require 'adva/routing_filters/section_path'
require 'adva/routing_filters/section_root'
require 'adva/controller/abstract_actions'
require 'adva/controller/references'
require 'adva/active_record/has_one_default'
require 'adva/active_record/has_options'
require 'adva/view/form'
require 'adva/view/helper/i18n'
require 'adva/view/tabs'

require 'core_ext/ruby/module/include_anonymous'
require 'core_ext/rails/action_view/has_many_through_collection_helpers'
require 'core_ext/rails/active_record/skip_callbacks'

at_exit { I18n.missing_translations.dump } if Rails.env.test?

module Adva
  class Core < ::Rails::Engine
    include Adva::Engine

    initializer 'adva-core.register_middlewares.static' do
      config.app_middleware.insert_before('Rack::Lock', Adva::Rack::Static)
    end

    initializer 'adva-core.register_middlewares.log_missing_translations' do
      config.app_middleware.use(I18n::MissingTranslations) if Rails.env.development?
    end

    initializer 'adva-core.require_section_types' do
      config.to_prepare { require_dependency 'page' }
    end

    initializer 'adva-core.setup_minimal' do
      require 'inherited_resources/helpers'

      Minimal::Template::FormBuilderProxy::PROXY_TAGS << :simple_form_for << :simple_fields_for
      Minimal::Template.class_eval do
        include Minimal::Template::FormBuilderProxy
        include Minimal::Template::TranslatedTags
        include InheritedResources::Helpers::LinkTo
        include FormHelper
      end
      ActionView::Template.register_template_handler('rb', Minimal::Template::Handler)
    end

    initializer 'adva-core.register_asset_expansions' do
      ActionView::Helpers::AssetTagHelper.register_javascript_expansion(
        :common  => %w(),
        :simple  => %w(),
        :default => %w(),
        :admin   => %w( adva-core/jquery/jquery-1.4.2.min.js
                        adva-core/jquery/jquery.tablednd_0_5.js
                        adva-core/jquery/jquery.table_tree.js
                        adva-core/rails
                        adva-core/admin )
      )

      ActionView::Helpers::AssetTagHelper.register_stylesheet_expansion(
        :common  => %w( adva-core/common/reset
                        adva-core/common/layout
                        adva-core/common/styles
                        adva-core/common/forms ),

        :simple  => %w( adva-core/simple/layout ),

        :default => %w( adva-core/default/layout
                        adva-core/default/styles ),

        :admin   => %w( adva-core/common/reset
                        adva-core/admin/layout
                        adva-core/admin/navigation
                        adva-core/admin/sidebar
                        adva-core/admin/styles
                        adva-core/admin/forms
                        adva-core/admin/lists )
      )
    end

    if Rails.env.development?
      initializer 'adva-core.schedule_slice_clearing' do
        config.to_prepare do
          Adva.loaded_slices.clear
        end
      end
    end
  end
end

# Wether some code needs to be implemented or should not be implemented, is
# like to be the subject of an argmument.
class NotToBeImplementedError < ArgumentError
end

# Resulting from the decision that something should not be implemented we get
# a deprecation if some code exists. Furthermore, if the code has potentially
# dangerous side effects.
class StronglyDeprecatedCodeError < NotToBeImplementedError
end
