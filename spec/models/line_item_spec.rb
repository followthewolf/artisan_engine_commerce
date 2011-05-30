require 'spec_helper'

describe LineItem do
  let( :new_line_item ) { LineItem.new :order => mock_model( Order ),
                                       :name  => 'Awesomesauce',
                                       :sku   => 'VAR-01',
                                       :price => 1000 }
  
  context "validations: " do
    it "is valid with valid attributes" do
      new_line_item.should be_valid
    end
    
    it "is not valid without an order" do
      new_line_item.order = nil
      new_line_item.should_not be_valid
    end
    
    it "is not valid without a name" do
      new_line_item.name = nil
      new_line_item.should_not be_valid
    end
    
    it "is not valid without a SKU" do
      new_line_item.sku = nil
      new_line_item.should_not be_valid
    end
    
    it "is not valid without a price greater than 1" do
      for invalid_price in [ -1, 0, 0.001 ]
        new_line_item.price = invalid_price
        new_line_item.should_not be_valid
      end
    end
    
    it "is not valid without a quantity" do
      new_line_item.quantity = nil
      new_line_item.should_not be_valid
    end
  end
  
  describe "quantity: " do
    it "has a default quantity of 1" do
      new_line_item.quantity.should == 1
    end
  end
end