class OrderTransactionsController < FrontController
  protect_from_forgery :except => [ :ipns ]
    
  def ipns
    params.delete( "controller" )
    params.delete( "action" )
    
    if valid_secret? and transaction_has_not_been_handled?
      @ot = OrderTransaction.create!( :order_id  => params[ :invoice ],
                                      :reference => params[ :txn_id ],
                                      :amount    => params[ :mc_gross ].to_money,
                                      :message   => 'Instant Payment Notification received from PayPal',
                                      :action    => 'purchase',
                                      :params    => params )
      
      if params[ :payment_status ] == 'Completed'
        @ot.success = true
        @ot.order.purchase!

        @ot.order.adjustments.create! :amount  => params[ :tax ].to_money, 
                                      :message => 'PayPal-Calculated Tax' unless params[ :tax ].to_money.zero?
                                      
        @ot.order.adjustments.create! :amount  => params[ :mc_shipping ].to_money, 
                                      :message => 'PayPal-Calculated Shipping' unless params[ :mc_shipping ].to_money.zero?
                                      
        @ot.order.adjustments.create! :amount  => ( "-" + params[ :payment_fee ] ).to_money, 
                                      :message => 'PayPal Transaction Fee' unless params[ :payment_fee ].to_money.zero?
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