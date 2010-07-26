class CartMailer < ActionMailer::Base
  def order_confirmation_email(site, cart)
    recipients    cart.email
    from          "#{site.name} <notifications@#{site.host}>"
    subject       "Your order confirmation"
    sent_on       Time.now
    body          { }
  end

  def order_notification_email(site, admin)
    recipients    admin.email
    from          "#{site.name} <notifications@#{site.host}>"
    subject       "New order"
    sent_on       Time.now
    body          { }
  end
end