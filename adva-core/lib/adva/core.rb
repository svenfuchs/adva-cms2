require 'adva'

module Adva
  class Core < ::Rails::Engine

    rake_tasks do
      require 'adva/core/tasks.rb'
    end
    
    initializer 'adva-core.patches' do
      Dir[File.expand_path("#{root}/lib/patches/**/*.rb", __FILE__)].each do |file|
        require file
      end
    end

    initializer 'adva-core.require_section_types' do
      require 'page'
    end

    initializer 'adva-core.load_redirects' do
      require root.join('config/redirects')
    end

    # TODO dry up with adva.user.register_middlewares
    initializer 'adva-core.register_middlewares' do
      urls = ["/stylesheets/adva_core", "/javascripts/adva_core", "/images/adva_core"]
      Rails.application.config.middleware.use Rack::Static, :urls => urls, :root => "#{root}/public"
    end

    initializer 'adva-core.register_asset_expansions' do
      ActionView::Helpers::AssetTagHelper.register_javascript_expansion \
        :admin   => %w( adva_core/admin/jquery.admin.js
                        adva_core/jquery/jquery.tablednd_0_5.js
                        adva_core/jquery/jquery.table_tree.js
                        adva_core/admin/jquery.table_tree.js
                        adva_core/admin/jquery.article.js
                        adva_core/admin/jquery.cached_pages.js
                        adva_core/jquery/jquery.qtip.min.js ),
        :default => %w( adva_core/jquery.roles 
                        adva_core/jquery.dates 
                        adva_core/parseuri 
                        adva_core/application ),
        :common  => %w( adva_core/jquery/jquery
                        adva_core/jquery/jquery-lowpro
                        adva_core/jquery/jquery-ui
                        adva_core/json
                        adva_core/cookie
                        adva_core/jquery.flash
                        adva_core/application )
        # :login   => %w(),
        # :simple  => %w(),
        # # From qtip dev branch
        # :qtip    => %w( adva_core/jquery/qtip/jquery.qtip adva_core/jquery/qtip/jquery.qtip.tips
        #                 adva_core/jquery/qtip/jquery.qtip.border adva_core/jquery/qtip/jquery.qtip.preload
        #                 adva_core/jquery/qtip/jquery.qtip.bgiframe adva_core/jquery/qtip/jquery.qtip.imagemap )

      ActionView::Helpers::AssetTagHelper.register_stylesheet_expansion \
        :admin   => %w( adva_core/admin/reset
                        adva_core/admin/layout
                        adva_core/admin/common
                        adva_core/admin/header
                        adva_core/admin/top
                        adva_core/admin/sidebar
                        adva_core/admin/forms
                        adva_core/admin/lists
                        adva_core/admin/content
                        adva_core/admin/themes
                        adva_core/admin/helptip
                        adva_core/admin/users
                        adva_core/jquery/jquery-ui.css
                        adva_core/jquery/jquery.tooltip.css ),
        :default => %w( adva_core/default 
                        adva_core/common 
                        adva_core/forms )
        # :login   => %w( adva_core/admin/reset adva_core/admin/common adva_core/admin/forms
        #                 adva_core/layout/login ),
        # :simple  => %w( adva_core/reset adva_core/admin/common adva_core/admin/forms
        #                 adva_core/layout/simple ),
        # :admin_projection => %w( adva_core/admin/projection ),
        # # admin alternate tryout, mainly for fixing IE7 related problems
        # :admin_alternate  => %w( adva_core/admin/reset adva_core/admin/alternate/layout adva_core/admin/alternate/common
        #                          adva_core/admin/alternate/header adva_core/admin/alternate/top adva_core/admin/alternate/sidebar
        #                          adva_core/admin/alternate/forms adva_core/admin/alternate/lists adva_core/admin/content
        #                          adva_core/admin/themes adva_core/admin/helptip adva_core/admin/users adva_core/jquery/jquery-ui
        #                          adva_core/jquery/alternate/jquery.tooltip ),
        # # From qtip dev branch
        # :qtip  => %w( adva_core/jquery/qtip/jquery.qtip )
    end
  end
end