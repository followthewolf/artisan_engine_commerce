class OrderMailer < ActionMailer::Base
  default :from => ArtisanEngine::Commerce.from_email
  
  def fulfillment_email( patron, fulfillment )
    @patron      = patron
    @fulfillment = fulfillment
    
    mail( :to      => patron.email,
          :subject => "Your order has shipped!" )
  end
end