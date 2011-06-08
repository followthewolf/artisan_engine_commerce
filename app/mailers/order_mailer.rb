class OrderMailer < ActionMailer::Base
  default :from => ArtisanEngine::Commerce.from_email
  
  def artisan_order_confirmation_email( order )
    @order = order
    
    mail( :to      => ArtisanEngine::Commerce.artisan_email,
          :subject => "You have received an order!" )
  end
  
  def patron_order_confirmation_email( order )
    @order  = order
    @patron = @order.patron
    
    mail( :to      => @patron.email,
          :subject => "Thank you for your order!" )
  end
  
  def fulfillment_email( patron, fulfillment )
    @patron      = patron
    @fulfillment = fulfillment
    
    mail( :to      => patron.email,
          :subject => "Your order has shipped!" )
  end
end