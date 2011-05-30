class OrderTransactionsController < FrontController
  protect_from_forgery :except => [ :ipns ]
    
  def ipns
    puts "Receiving IPN ..."
    puts params
    params.delete( "controller" )
    params.delete( "action" )
    
    if valid_secret? and transaction_has_not_been_handled?
      @ot = OrderTransaction.create!( :order_id  => params[ :invoice ],
                                      :reference => params[ :txn_id ],
                                      :amount    => params[ :settle_amount ],
                                      :message   => 'Instant Payment Notification received from PayPal',
                                      :action    => 'purchase',
                                      :params    => params )
      
      if params[ :payment_status ] == 'Completed'
        @ot.success = true
        @ot.order.purchase!
        
        @ot.order.adjustments.create! :amount  => params[ :tax ], 
                                      :message => 'PayPal-Calculated Tax' unless params[ :tax ].to_f.zero?
        @ot.order.adjustments.create! :amount  => params[ :shipping ], 
                                      :message => 'PayPal-Calculated Shipping' unless params[ :shipping ].to_f.zero?
      else
        @ot.success = false
      end
      
      @ot.save
    end
    
    render :nothing => true
  end
  
  private
  
    def valid_secret?
      ArtisanEngine::Commerce::PaypalWPS.secret == params[ :secret ]
    end
    
    def transaction_has_not_been_handled?
      !OrderTransaction.find_by_reference( params[ :txn_id ] )
    end
end