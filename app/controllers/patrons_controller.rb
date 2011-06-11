class PatronsController < FrontController
  respond_to :html 
  
  def subscribe
    @patron            = Patron.find_or_initialize_by_email( params[ :email ] )
    @patron.subscribed = true
    
    flash[ :subscribe_notice ] = @patron.save ? 'Thank you for joining.' : 'You have entered an invalid E-Mail.'
    redirect_to :back
  end
end