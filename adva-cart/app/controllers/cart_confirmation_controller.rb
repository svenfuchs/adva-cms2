class CartConfirmationController < BaseController
  def create
    # TODO
    CartMailer.order_confirmation_email(current_site, current_cart).deliver
    CartMailer.order_notification_email(current_site, current_cart, User.find_by_email('admin@admin.org')).deliver
    current_cart.destroy
    session.delete(:cart_id)
    redirect_to :controller => :cart_confirmation, :action => :show
  end

  protected

    def resource
      current_cart
    end

    def build_resource
      current_cart
    end

    def begin_of_association_chain
      current_cart
    end
end