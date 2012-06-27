[33mcommit c1033aefb50419540720e3728ace19475cb0d79a[m
Author: Niklas Hofer <niklas+dev@lanpartei.de>
Date:   Tue Jun 5 12:06:25 2012 +0200

    apply ALL the patches to the new rails version

[1mdiff --git a/adva-core/lib/patches/rails/integretion_runner_respond_to.rb b/adva-core/lib/patches/rails/integretion_runner_respond_to.rb[m
[1mindex 31d3360..9179f6a 100644[m
[1m--- a/adva-core/lib/patches/rails/integretion_runner_respond_to.rb[m
[1m+++ b/adva-core/lib/patches/rails/integretion_runner_respond_to.rb[m
[36m@@ -4,7 +4,7 @@[m [mrequire 'gem-patching'[m
 # respond_to? method. It thus doesn't respond_to? to named route url helpers even[m
 # though it actually responds to them. Happens with the PolymorphicRoutes patch[m
 # above, so this patch is here as well.[m
[31m-Gem.patching('rails', '3.0.9') do[m
[32m+[m[32mGem.patching('rails', '3.0.13') do[m
   ActionDispatch::Integration::Runner.module_eval do[m
     def respond_to?(method, include_private = false)[m
       @integration_session.respond_to?(method, include_private) || super[m
[1mdiff --git a/adva-core/lib/patches/rails/polymorphic_url_for.rb b/adva-core/lib/patches/rails/polymorphic_url_for.rb[m
[1mindex 796902d..8512224 100644[m
[1m--- a/adva-core/lib/patches/rails/polymorphic_url_for.rb[m
[1m+++ b/adva-core/lib/patches/rails/polymorphic_url_for.rb[m
[36m@@ -3,7 +3,7 @@[m
 # see https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/2986-polymorphic_url-should-handle-sti-better[m
 #[m
 # FIXME: this should not blindly overwrite ActionDispatch::Routing::PolymorphicRoutes.build_named_route_call[m
[31m-Gem.patching('rails', '3.0.9') do[m
[32m+[m[32mGem.patching('rails', '3.0.13') do[m
   require 'action_dispatch/routing/polymorphic_routes'[m
 [m
   ActionDispatch::Routing::PolymorphicRoutes.module_eval do[m
[1mdiff --git a/adva-core/lib/patches/rails/recognize_path_env.rb b/adva-core/lib/patches/rails/recognize_path_env.rb[m
[1mindex ae8a02a..5e6a281 100644[m
[1m--- a/adva-core/lib/patches/rails/recognize_path_env.rb[m
[1m+++ b/adva-core/lib/patches/rails/recognize_path_env.rb[m
[36m@@ -2,7 +2,7 @@[m
 #[m
 # FIXME: patch this better, do not override the whole method[m
 [m
[31m-Gem.patching('rails', '3.0.9') do[m
[32m+[m[32mGem.patching('rails', '3.0.13') do[m
   require 'action_dispatch/routing/mapper'[m
   require 'action_dispatch/routing/route_set'[m
 [m
[1mdiff --git a/adva-core/lib/patches/rails/route_set_to_param.rb b/adva-core/lib/patches/rails/route_set_to_param.rb[m
[1mindex 8a40a25..fcd32b2 100644[m
[1m--- a/adva-core/lib/patches/rails/route_set_to_param.rb[m
[1m+++ b/adva-core/lib/patches/rails/route_set_to_param.rb[m
[36m@@ -2,7 +2,7 @@[m
 # if arity allows it. so we can use param names in routes and distinguish them[m
 # in the model.[m
 [m
[31m-Gem.patching('rails', '3.0.9') do[m
[32m+[m[32mGem.patching('rails', '3.0.13') do[m
   require 'action_dispatch/routing/route_set'[m
 [m
   ActionDispatch::Routing::RouteSet::Generator.class_eval do[m
[1mdiff --git a/adva-core/lib/patches/rails/route_set_trailing_segment.rb b/adva-core/lib/patches/rails/route_set_trailing_segment.rb[m
[1mindex a3abead..e6c369b 100644[m
[1m--- a/adva-core/lib/patches/rails/route_set_trailing_segment.rb[m
[1m+++ b/adva-core/lib/patches/rails/route_set_trailing_segment.rb[m
[36m@@ -1,7 +1,7 @@[m
 require 'gem-patching'[m
 [m
 # remove trailing segments '.1' and  query params '?=1' from url[m
[31m-Gem.patching('rails', '3.0.9') do[m
[32m+[m[32mGem.patching('rails', '3.0.13') do[m
   ActionDispatch::Routing::RouteSet.class_eval do[m
     def url_for_with_singleton_resource_patch(options)[m
       url_for_without_singleton_resource_patch(options).[m
[1mdiff --git a/adva-core/lib/patches/rails/sti_associations.rb b/adva-core/lib/patches/rails/sti_associations.rb[m
[1mindex 7984903..1718cb6 100644[m
[1m--- a/adva-core/lib/patches/rails/sti_associations.rb[m
[1m+++ b/adva-core/lib/patches/rails/sti_associations.rb[m
[36m@@ -4,7 +4,7 @@[m [mrequire 'gem-patching'[m
 # i.e.: site.sections.build(:type => 'Page').class == Page[m
 # http://pragmatig.com/2010/06/04/fixing-rails-nested-attributes-on-collections-with-sti[m
 [m
[31m-Gem.patching('rails', '3.0.9') do[m
[32m+[m[32mGem.patching('rails', '3.0.13') do[m
   class ActiveRecord::Reflection::AssociationReflection[m
     def build_association(*options, &block)[m
       if options.first.is_a?(Hash) && options.first[:type].present?[m
[1mdiff --git a/adva-core/lib/patches/rails/translation_helper.rb b/adva-core/lib/patches/rails/translation_helper.rb[m
[1mindex a21aa24..038c73f 100644[m
[1m--- a/adva-core/lib/patches/rails/translation_helper.rb[m
[1m+++ b/adva-core/lib/patches/rails/translation_helper.rb[m
[36m@@ -3,7 +3,7 @@[m
 #[m
 # See https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/5969-bump-i18n-and-make-translationhelper-use-new-rescue_format-option#ticket-5969-8[m
 # can be removed in 3.1[m
[31m-Gem.patching('rails', '3.0.9') do[m
[32m+[m[32mGem.patching('rails', '3.0.13') do[m
   ActionView::Helpers::TranslationHelper.module_eval do[m
     def translate(key, options = {})[m
       options.merge!(:rescue_format => :html) unless options.key?(:rescue_format)[m
