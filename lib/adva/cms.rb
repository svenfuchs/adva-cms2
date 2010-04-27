module Adva
  class Cms < ::Rails::Engine
    initializer 'adva.cms.register_section_types' do
      require 'page'
    end

    initializer 'adva.cms.register_middlewares' do
      Rails.application.config.middleware.use Rack::Static, :urls => ["/stylesheets/adva_cms", "/javascripts/adva_cms", "/images/adva_cms"],
                                                            :root => File.expand_path('../../../public', __FILE__)
    end

    initializer 'adva.cms.register_asset_expansions' do
      ActionView::Helpers::AssetTagHelper.register_javascript_expansion \
        :admin   => %w( adva_cms/admin/jquery.admin.js
                        adva_cms/jquery/jquery.tablednd_0_5.js
                        adva_cms/jquery/jquery.table_tree.js
                        adva_cms/admin/jquery.table_tree.js
                        adva_cms/admin/jquery.article.js
                        adva_cms/admin/jquery.cached_pages.js
                        adva_cms/jquery/jquery.qtip.min.js )
        # :default => %w( adva_cms/jquery.roles adva_cms/jquery.dates adva_cms/parseuri adva_cms/application )
        # :common  => %w( adva_cms/jquery/jquery adva_cms/jquery/jquery-lowpro adva_cms/jquery/jquery-ui
        #                 adva_cms/json adva_cms/cookie adva_cms/jquery.flash adva_cms/application ),
        # :login   => %w(),
        # :simple  => %w(),
        # # From qtip dev branch
        # :qtip    => %w( adva_cms/jquery/qtip/jquery.qtip adva_cms/jquery/qtip/jquery.qtip.tips
        #                 adva_cms/jquery/qtip/jquery.qtip.border adva_cms/jquery/qtip/jquery.qtip.preload
        #                 adva_cms/jquery/qtip/jquery.qtip.bgiframe adva_cms/jquery/qtip/jquery.qtip.imagemap )

      ActionView::Helpers::AssetTagHelper.register_stylesheet_expansion \
        :admin   => %w( adva_cms/admin/reset
                        adva_cms/admin/layout
                        adva_cms/admin/common
                        adva_cms/admin/header
                        adva_cms/admin/top
                        adva_cms/admin/sidebar
                        adva_cms/admin/forms
                        adva_cms/admin/lists
                        adva_cms/admin/content
                        adva_cms/admin/themes
                        adva_cms/admin/helptip
                        adva_cms/admin/users
                        adva_cms/jquery/jquery-ui.css
                        adva_cms/jquery/jquery.tooltip.css )
        # :default => %w( adva_cms/default adva_cms/common adva_cms/forms ),
        # :login   => %w( adva_cms/admin/reset adva_cms/admin/common adva_cms/admin/forms
        #                 adva_cms/layout/login ),
        # :simple  => %w( adva_cms/reset adva_cms/admin/common adva_cms/admin/forms
        #                 adva_cms/layout/simple ),
        # :admin_projection => %w( adva_cms/admin/projection ),
        # # admin alternate tryout, mainly for fixing IE7 related problems
        # :admin_alternate  => %w( adva_cms/admin/reset adva_cms/admin/alternate/layout adva_cms/admin/alternate/common
        #                          adva_cms/admin/alternate/header adva_cms/admin/alternate/top adva_cms/admin/alternate/sidebar
        #                          adva_cms/admin/alternate/forms adva_cms/admin/alternate/lists adva_cms/admin/content
        #                          adva_cms/admin/themes adva_cms/admin/helptip adva_cms/admin/users adva_cms/jquery/jquery-ui
        #                          adva_cms/jquery/alternate/jquery.tooltip ),
        # # From qtip dev branch
        # :qtip  => %w( adva_cms/jquery/qtip/jquery.qtip )
    end
  end
end