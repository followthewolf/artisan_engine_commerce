require 'spec_helper'

describe OrdersController do
  let( :order_from_session ) { mock_model( 'Order' ).as_null_object }
  
  before do
    controller.stub :current_order => order_from_session
  end
  
  describe "GET :new" do
    it "retrieves the order from the session" do
      get :new
      assigns( :order ).should == order_from_session
    end
  end
  
  describe "GET :edit" do
    let( :new_address ) { mock_model 'Address' }
    
    before do
      Address.stub :new => new_address
    end
    
    it "retrieves the order from the session" do
      get :edit
      assigns( :order ).should == order_from_session
    end
    
    it "assigns @shipping_address with a new shipping address" do
      get :edit
      assigns( :shipping_address ).should == new_address
    end
    
    it "assigns @billing_address with a new billing address" do
      get :edit
      assigns( :billing_address ).should == new_address
    end
  end
  
  describe "PUT :update" do
    let( :params )           { { :shipping_address => 'Shipping Parameters',
                                 :billing_address  => 'Billing Parameters',
                                 :order            => 'Order Parameters' } }
                                 
    let( :shipping_address ) { mock_model 'Address' }
    let( :billing_address )  { mock_model 'Address' }
    
    before do
      controller.stub :params => params
    end
    
    it "retrieves the order from the session" do
      put :update
      assigns( :order ).should == order_from_session
    end
    
    it "sets the order's shipping address" do
      Address.stub( :new ).and_return( shipping_address )
      order_from_session.should_receive( :shipping_address= ).with( shipping_address )
      put :update
    end
    
    it "sets the order's billing address" do
      Address.stub( :new ).and_return( billing_address )
      order_from_session.should_receive( :billing_address= ).with( billing_address )
      put :update
    end
    
    it "updates the order's attributes" do
      order_from_session.should_receive( :update_attributes ).with( 'Order Parameters' )
      put :update
    end

    context "if the order updates successfully and the addresses are both valid" do
      before do
        order_from_session.stub :update_attributes => true
      end
      
      it "checks out the order" do
        order_from_session.should_receive( :checkout! )
        put :update
      end
      
      context "and the order checks out successfully" do
        before { order_from_session.stub :checkout! => true }
        
        it "redirects to the PayPal form page" do
          put :update
          response.should redirect_to paypal_path
        end
      end
      
      context "and the order does not check out successfully" do
        before { order_from_session.stub :checkout! => false }
        
        it "renders the edit template" do
          put :update
          response.should render_template :edit
        end
      end
    end
    
    context "if the order does not update successfully" do 
      before { order_from_session.stub :update_attributes => false }
           
      it "renders the :edit template" do
        put :update
        response.should render_template :edit
      end
    end
  end
end