module AdvaUser
  module Authorization
    def self.included(controller)
      controller.class_eval do
        before_filter :authorize_user!
      end
    end

    def authorize_user!
      unless current_user.admin?
        redirect_to root_url, :flash => {:alert => I18n.translate('flash.admin.access_denied')}
      end
    end
  end
end
