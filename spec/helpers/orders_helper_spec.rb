require 'spec_helper'

describe OrdersHelper do
  describe "#current_order" do
    let( :new_order ) { mock_model 'Order' }
    
    context "if the session already contains an order ID" do
      let( :order_from_session ) { mock_model( 'Order' ).as_null_object }

      before do
        controller.stub( :session ).and_return( { :order_id => 1 } )
        Order.stub( :find ).and_return( order_from_session )
      end
      
      it "finds the order from the session" do
        Order.should_receive( :find ).with( 1 )
        helper.current_order
      end
            
      context "and the order is new or pending" do
        before do
          order_from_session.stub :new? => true
        end
        
        it "returns the order from the session" do
          order         = helper.current_order
          order.should == order_from_session
        end
      end
      
      context "and the order is not new or pending" do
        before do
          order_from_session.stub :new?     => false
          order_from_session.stub :pending? => false
        end
        
        it "creates a new order and stores it in the session" do
          Order.should_receive( :create! ).and_return( new_order )
          
          order         = helper.current_order
          order.should == new_order
        end
      end
    end
    
    context "if the session does not already contain an order" do
      before do
        controller.stub( :session ).and_return( { :order_id => nil } )
      end
      
      it "creates a new order and stores it in the session" do
        Order.should_receive( :create! ).and_return( new_order )
        
        order         = helper.current_order
        order.should == new_order
      end
    end
  end      
end