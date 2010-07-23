BaseController.class_eval do
  def current_cart
    @current_cart ||= begin
      if session[:cart_id]
        Cart.find(session[:cart_id])
      else
        Cart.create(params[:cart]).tap { |cart| session[:cart_id] = cart.id }
      end
    end
  end
  helper_method :current_cart
end
