require 'devise'

module Adva
  class Cms < ::Rails::Engine
    rake_tasks do
      load 'tasks/adva/cms/install.rake'
    end
    
    initializer 'adva.cms.patches' do
      Dir[File.expand_path('../../patches/**/*.rb', __FILE__)].each do |file|
        require file
      end
    end

    initializer 'adva.cms.register_section_types' do
      require 'page'
    end

    # initializer 'adva.cms.config.load_paths' do
    #   Rails.application.config.load_paths.push("#{config.root}/responders")
    # end

    initializer 'adva.cms.register_middlewares' do
      urls = ["/stylesheets/adva_cms", "/javascripts/adva_cms", "/images/adva_cms"]
      root = File.expand_path('../../../public', __FILE__)
      Rails.application.config.middleware.use Rack::Static, :urls => urls, :root => root
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
    
    initializer 'adva.cms.devise' do
      # Use this hook to configure devise mailer, warden hooks and so forth. The first
      # four configuration values can also be set straight in your models.
      Devise.setup do |config|
        # Configure the e-mail address which will be shown in DeviseMailer.
        config.mailer_sender = "please-change-me@config-initializers-devise.com"

        # ==> Configuration for any authentication mechanism
        # Configure which keys are used when authenticating an user. By default is
        # just :email. You can configure it to use [:username, :subdomain], so for
        # authenticating an user, both parameters are required. Remember that those
        # parameters are used only when authenticating and not when retrieving from
        # session. If you need permissions, you should implement that in a before filter.
        # config.authentication_keys = [ :email ]

        # Tell if authentication through request.params is enabled. True by default.
        # config.params_authenticatable = true

        # Tell if authentication through HTTP Basic Auth is enabled. True by default.
        # config.http_authenticatable = true

        # The realm used in Http Basic Authentication
        # config.http_authentication_realm = "Application"

        # ==> Configuration for :database_authenticatable
        # Invoke `rake secret` and use the printed value to setup a pepper to generate
        # the encrypted password. By default no pepper is used.
        # config.pepper = "rake secret output"

        # Configure how many times you want the password is reencrypted. Default is 10.
        # config.stretches = 10

        # Define which will be the encryption algorithm. Supported algorithms are :sha1
        # (default), :sha512 and :bcrypt. Devise also supports encryptors from others
        # authentication tools as :clearance_sha1, :authlogic_sha512 (then you should set
        # stretches above to 20 for default behavior) and :restful_authentication_sha1
        # (then you should set stretches to 10, and copy REST_AUTH_SITE_KEY to pepper)
        # config.encryptor = :sha1

        # ==> Configuration for :confirmable
        # The time you want give to your user to confirm his account. During this time
        # he will be able to access your application without confirming. Default is nil.
        # config.confirm_within = 2.days

        # ==> Configuration for :rememberable
        # The time the user will be remembered without asking for credentials again.
        # config.remember_for = 2.weeks

        # ==> Configuration for :validatable
        # Range for password length
        # config.password_length = 6..20

        # Regex to use to validate the email address
        # config.email_regexp = /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i

        # ==> Configuration for :timeoutable
        # The time you want to timeout the user session without activity. After this
        # time the user will be asked for credentials again.
        # config.timeout_in = 10.minutes

        # ==> Configuration for :lockable
        # Defines which strategy will be used to lock an account.
        # :failed_attempts = Locks an account after a number of failed attempts to sign in.
        # :none            = No lock strategy. You should handle locking by yourself.
        # config.lock_strategy = :failed_attempts

        # Defines which strategy will be used to unlock an account.
        # :email = Sends an unlock link to the user email
        # :time  = Reanables login after a certain ammount of time (see :unlock_in below)
        # :both  = Enables both strategies
        # :none  = No unlock strategy. You should handle unlocking by yourself.
        # config.unlock_strategy = :both

        # Number of authentication tries before locking an account if lock_strategy
        # is failed attempts.
        # config.maximum_attempts = 20

        # Time interval to unlock the account if :time is enabled as unlock_strategy.
        # config.unlock_in = 1.hour

        # ==> Configuration for :token_authenticatable
        # Defines name of the authentication token params key
        # config.token_authentication_key = :auth_token

        # ==> General configuration
        # Load and configure the ORM. Supports :active_record (default), :mongoid
        # (requires mongo_ext installed) and :data_mapper (experimental).
        require 'devise/orm/active_record'

        # Turn scoped views on. Before rendering "sessions/new", it will first check for
        # "sessions/users/new". It's turned off by default because it's slower if you
        # are using only default views.
        # config.scoped_views = true

        # By default, devise detects the role accessed based on the url. So whenever
        # accessing "/users/sign_in", it knows you are accessing an User. This makes
        # routes as "/sign_in" not possible, unless you tell Devise to use the default
        # scope, setting true below.
        # config.use_default_scope = true

        # Configure the default scope used by Devise. By default it's the first devise
        # role declared in your routes.
        # config.default_scope = :user

        # If you want to use other strategies, that are not (yet) supported by Devise,
        # you can configure them inside the config.warden block. The example below
        # allows you to setup OAuth, using http://github.com/roman/warden_oauth
        #
        # config.warden do |manager|
        #   manager.oauth(:twitter) do |twitter|
        #     twitter.consumer_secret = <YOUR CONSUMER SECRET>
        #     twitter.consumer_key  = <YOUR CONSUMER KEY>
        #     twitter.options :site => 'http://twitter.com'
        #   end
        #   manager.default_strategies(:scope => :user).unshift :twitter_oauth
        # end
      end
    end
  end
end