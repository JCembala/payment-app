class OrderMailer < ApplicationMailer
  def checkout_complete(order)
    @order = order
    mail(to: order.user.email, subject: 'Order Complete')
  end

  def checkout_expired(order)
    @order = order
    mail(to: order.user.email, subject: 'Order Expired')
  end
end
