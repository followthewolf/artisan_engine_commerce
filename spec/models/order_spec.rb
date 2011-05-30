require 'spec_helper'

describe Order do
  let( :new_order ) { Order.new }
  
  describe "validations: " do
    it "is not valid without a status" do
      new_order.status = nil
      new_order.should_not be_valid
    end
  end
  
  describe "status: " do
    it "has a default status of 'new'" do
      new_order.status.should == 'new'
    end
    
    describe "#checkout!" do
      let( :order ) { Order.create! }
      
      context "validations: " do
        it "is not valid without an E-Mail" do
          order.email = nil
          order.checkout!.should be_false
        end
        
        it "is not valid without a shipping address" do
          order.shipping_address = nil
          order.checkout!.should be_false
        end
        
        it "is not valid without a billing address" do
          order.billing_address = nil
          order.checkout!.should be_false
        end
      end
      
      context "if valid: " do
        let ( :order ) { Order.create! }
        
        before do
          order.email            = 'patron@example.com'
          order.billing_address  = Factory :address
          order.shipping_address = Factory :address
        end
        
        context "if a patron exists with the order's E-Mail" do
          before do
            @existing_patron = Factory :patron, :email => 'patron@example.com'
          end
          
          it "sets the patron to the existing patron" do
            expect {
              order.checkout!
            }.not_to change( Patron, :count )
            
            order.patron.should == @existing_patron
          end
        end
        
        context "if a patron does not exist with the order's E-Mail" do
          it "creates a new patron with the billing address's first and last name" do
            expect {
              order.checkout!
            }.to change( Patron, :count ).by( 1 )
            
            order.patron.email.should      == 'patron@example.com'
            order.patron.first_name.should == order.billing_address.first_name
            order.patron.last_name.should  == order.billing_address.last_name
          end
        end
                                       
        it "checks out the order (status: pending)" do
          order.checkout!.should be_true
          order.should be_pending
        end
      end
    end
  
    describe "#purchase!" do
      let( :order ) { Factory :pending_order }
      
      it "transitions from pending to purchased status" do
        order.purchase!.should be_true
        order.should be_purchased
      end
    end
  end
  
  describe "when setting a shipping address" do
    let( :order ) { Order.create! }
    
    context "if an address with the same attributes already exists" do
      before do
        @address_attributes = Factory.attributes_for :address
        @existing_address   = Address.create! @address_attributes
      end
      
      it "sets the order's address to the existing address" do
        expect { 
          order.shipping_address = Address.new @address_attributes
        }.not_to change( Address, :count )
        
        order.shipping_address.should == @existing_address
      end
    end
    
    context "if an address with the same attributes does not already exist" do
      let( :new_address ) { Factory.build :address }
      
      it "creates and sets the order's address to the new address" do
        expect { 
          order.shipping_address = new_address 
        }.to change( Address, :count ).by( 1 )
        
        order.shipping_address.should == new_address
      end
    end
  end

  describe "when setting a billing address" do
    let( :order ) { Order.create! }
    
    context "if an address with the same attributes already exists" do
      before do
        @address_attributes = Factory.attributes_for :address
        @existing_address   = Address.create! @address_attributes
      end
      
      it "sets the order's address to the existing address" do
        expect { 
          order.billing_address = Address.new @address_attributes
        }.not_to change( Address, :count )
        
        order.billing_address.should == @existing_address
      end
    end
    
    context "if an address with the same attributes does not already exist" do
      let( :new_address ) { Factory.build :address }
      
      it "creates and sets the order's address to the new address" do
        expect { 
          order.billing_address = new_address 
        }.to change( Address, :count ).by( 1 )
        
        order.billing_address.should == new_address
      end
    end
  end
  
  describe "#new_line_item" do
    let( :order ) { Order.create! }

    context "when given a variant" do
      let( :variant ) { Factory :small_blue_variant }
    
      context "if a duplicate line item does not already exist in the order" do
        before do
          order.stub :line_item_exists? => false
        end
              
        it "returns a populated new line item using the variant" do
          new_line_item = order.new_line_item_from( variant )

          new_line_item.should be_a LineItem
          new_line_item.should be_new_record

          new_line_item.order.should    == order
          new_line_item.name.should     == variant.good.name
          new_line_item.price.should    == variant.price
          new_line_item.sku.should      == variant.sku
          new_line_item.options.should  == variant.option_values_to_s
        end
      end
    
      context "if a duplicate line item exists in the order" do
        let( :duplicate_line_item ) { stub_model LineItem, :quantity => 1 }
      
        before do
          order.stub :line_item_exists? => duplicate_line_item
        end
      
        it "returns the existing line item with its quantity incremented by 1" do
          new_line_item = order.new_line_item_from( variant )
          
          new_line_item.should          == duplicate_line_item
          new_line_item.quantity.should == 2
        end
      end
    end
    
    context "when not given a variant" do
      it "returns a blank line item populated with the order only" do
        blank_line_item = order.new_line_item_from
      
        blank_line_item.should be_a LineItem
        blank_line_item.should be_new_record
      
        blank_line_item.order.should == order
        blank_line_item.name.should be_nil
      end
    end
  end
  
  describe "#line_item_exists?" do
    it "returns true if a line item with matching attributes belongs to the order" do
      order            = Order.create!
      variant          = Factory :small_blue_variant
      line_item_params = { :sku   => variant.sku, 
                           :name  => variant.good.name, 
                           :price => variant.price }

      duplicate     = order.line_items.create!( line_item_params )
      new_line_item = order.line_items.build( line_item_params )
      
      order.line_item_exists?( variant ).should be_true
    end
  end
end