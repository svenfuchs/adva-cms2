BaseController.class_eval do
  def current_cart
    @current_cart ||= session[:cart_id] ? Cart.find(session[:cart_id]) : Cart.create.tap { |cart| session[:cart_id] = cart.id }
  end
  helper_method :current_cart
end
