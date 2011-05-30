require 'spec_helper'

describe OrderTransactionsController do
  describe "POST /ipns" do
    let( :params ) { { "txn_id"         => 'TESTTRANS',
                       "invoice"        => '1',
                       "payment_status" => 'Completed',
                       "mc_gross"       => '500.35',
                       "tax"            => '5.00', 
                       "mc_shipping"    => '25.00',
                       "payment_fee"    => "1.28" } }
    
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
                                                            :amount    => params[ "mc_gross" ].to_money,
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
            it "creates order adjustments for tax, shipping, and PayPal fee" do
              order_transaction.order.adjustments.should_receive( :create! ).with( :amount => "5.00".to_money, 
                                                                                   :message => "PayPal-Calculated Tax" )
              order_transaction.order.adjustments.should_receive( :create! ).with( :amount => "25.00".to_money, 
                                                                                   :message => "PayPal-Calculated Shipping" )
              order_transaction.order.adjustments.should_receive( :create! ).with( :amount => "-1.28".to_money,
                                                                                   :message => "PayPal Transaction Fee" )
              
              post 'ipns', params
            end
            
            it "does not create an order adjustment if the tax, shipping, or fee is 0" do
              params[ :tax ]         = "0.00"
              params[ :mc_shipping ] = "0.00"
              params[ :payment_fee ] = "0.00"
              
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