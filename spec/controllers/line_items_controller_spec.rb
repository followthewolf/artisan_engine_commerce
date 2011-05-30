require 'spec_helper'

describe LineItemsController do  
  describe "POST :create" do
    let( :params )        { { :line_item => { :good_id => 1 },
                              :option_value_ids => [ 1, 5 ] } }
                              
    let( :new_line_item ) { mock_model( 'LineItem' ).as_null_object }
    let( :current_order ) { mock_model 'Order' }
    let( :found_variant ) { mock_model 'Variant' }
    
    before do
      controller.stub    :current_order                  => current_order
      current_order.stub :new_line_item_from             => new_line_item
      Variant.stub       :find_by_good_and_option_values => found_variant
    end
    
    it "finds the variant from the parameters" do
      Variant.should_receive( :find_by_good_and_option_values ).with( 1, [ 1, 5 ] )
      post :create, params
    end
    
    it "asks the current order for a new line item using the variant" do
      current_order.should_receive( :new_line_item_from ).with( found_variant )
      post :create, params
    end
    
    it "saves the line item" do
      new_line_item.should_receive( :save )
      post :create, params
    end
    
    it "redirects to the new order page" do
      post :create, params
      response.should redirect_to new_order_path
    end
  end
end