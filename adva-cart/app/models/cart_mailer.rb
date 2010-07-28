class CartMailer < ActionMailer::Base
  attr_reader :site, :cart, :admin
  helper_method :site, :cart, :admin

  def order_confirmation_email(site, cart)
    @site, @cart = site, cart

    mail :to      => cart.email,
         :from    => "#{site.name} <notifications@#{site.host}>",
         :subject => "Your order confirmation"
  end

  def order_notification_email(site, cart, admin)
    @site, @cart, @admin = site, cart, admin

    mail :to      => admin.email,
         :from    => "#{site.name} <notifications@#{site.host}>",
         :subject => "New order"
  end
end