require 'spec_helper'

describe OrderTransactionsController do
  describe "POST /ipns" do
    let( :params ) { { "txn_id"         => 'TESTTRANS',
                       "invoice"        => '1',
                       "payment_status" => 'Completed',
                       "settle_amount"  => '500.35',
                       "tax"            => '5.00', 
                       "shipping"       => '25.00' } }
    
    let( :order_transaction ) { mock_model( 'OrderTransaction' ).as_null_object }
    let( :order )             { mock_model( 'Order' ).as_null_object }
    
    before do
      OrderTransaction.stub  :create! => order_transaction
      order_transaction.stub :order   => order
    end
    
    context "if the shared secret is intact" do
      before do
        controller.stub :valid_secret? => true
      end
      
      context "and the notification has not already been handled" do
        before do
          OrderTransaction.stub :find_by_reference => nil
        end
        
        it "creates an OrderTransaction (purchase) using PayPal's data" do
          OrderTransaction.should_receive( :create! ).with( :order_id  => params[ "invoice" ],
                                                            :reference => params[ "txn_id" ],
                                                            :amount    => params[ "settle_amount" ],
                                                            :message   => 'Instant Payment Notification received from PayPal',
                                                            :action    => 'purchase',
                                                            :params    => params )
          
          post 'ipns', params
        end
      
        context "and the notification has Completed status" do
          it "it sets the OrderTransaction's success boolean to true" do
            order_transaction.should_receive( :success= ).with( true )
            post 'ipns', params
          end
          
          describe "order adjustments: " do
            it "creates order adjustments for tax and shipping" do
              order_transaction.order.adjustments.should_receive( :create! ).with( :amount => "5.00", 
                                                                                   :message => "PayPal-Calculated Tax" )
              order_transaction.order.adjustments.should_receive( :create! ).with( :amount => "25.00", 
                                                                                   :message => "PayPal-Calculated Shipping" )
            
              post 'ipns', params
            end
            
            it "does not create an order adjustment if the tax or shipping is 0" do
              params[ :tax ] = "0.00"
              params[ :shipping ] = "0.00"
              
              order_transaction.order.adjustments.should_not_receive( :create! )
            
              post 'ipns', params
            end
              
          end
          
          it "transitions the appropriate order to purchased status" do
            order_transaction.order.should_receive( :purchase! )
            post 'ipns', params
          end
        end

        context "and the notification does not have Completed status" do
          before do
            params[ "payment_status" ] = 'Incomplete'
          end
          
          it "maintains the OrderTransaction's success boolean at its default of false" do
            order_transaction.should_receive( :success= ).with( false )
            post 'ipns', params
          end
        end
        
        it "saves the OrderTransaction" do
          order_transaction.should_receive( :save )
          post 'ipns', params
        end
      end
    end
  end
end