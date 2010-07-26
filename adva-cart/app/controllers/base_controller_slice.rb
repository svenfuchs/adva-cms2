BaseController.class_eval do
  def current_cart
    @current_cart ||= begin
      cart = Cart.find(session[:cart_id]) if session[:cart_id] rescue nil
      cart ||= Cart.create(params[:cart]).tap { |cart| session[:cart_id] = cart.id }
      cart
    end
  end
  helper_method :current_cart
end
