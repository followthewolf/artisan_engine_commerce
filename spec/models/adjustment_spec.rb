require 'spec_helper'

describe Adjustment do
  let( :new_adjustment ) { Adjustment.new :order  => stub_model( Order ),
                                          :amount => 20 }
  
  context "validations: " do
    it "is valid with valid attributes" do
      new_adjustment.should be_valid
    end
    
    it "is not valid without an order" do
      new_adjustment.order = nil
      new_adjustment.should_not be_valid
    end
  end
end