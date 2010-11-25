require 'gem_patching'

# ActionDispatch::Integration::Runner defines method_missing but no accompaning
# respond_to? method. It thus doesn't respond_to? to named route url helpers even
# though it actually responds to them. Happens with the PolymorphicRoutes patch
# above, so this patch is here as well.
#
# See https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/6027-define-respond_to-on-actiondispatchintegrationrunner
Gem.patching('rails', '3.0.3') do
  ActionDispatch::Integration::Runner.module_eval do
    def respond_to?(method, include_private = false)
      @integration_session.respond_to?(method, include_private) || super
    end
  end
end
