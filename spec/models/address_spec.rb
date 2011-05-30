require 'spec_helper'

describe Address do
  let( :new_address ) { Address.new :first_name  => 'Johnny',
                                    :last_name   => 'Appleseed',
                                    :address1    => '12 Orchard Ln.',
                                    :city        => 'Applesville',
                                    :country     => 'US',
                                    :postal_code => 'ABC-123' }
  
  context "validations:" do
    it "is valid with valid attributes" do
      new_address.should be_valid
    end
    
    it "is not valid without a first name" do
      new_address.first_name = nil
      new_address.should_not be_valid
    end
    
    it "is not valid without a last name" do
      new_address.last_name = nil
      new_address.should_not be_valid
    end

    it "is not valid without an address1" do
      new_address.address1 = nil
      new_address.should_not be_valid
    end
    
    it "is not valid without a city" do
      new_address.city = nil
      new_address.should_not be_valid
    end
    
    it "is not valid without a country" do
      new_address.city = nil
      new_address.should_not be_valid
    end
    
    it "is not valid without a postal code" do
      new_address.postal_code = nil
      new_address.should_not be_valid
    end
  end
end