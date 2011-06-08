require File.expand_path( '../../../acceptance_helper', __FILE__ )

feature "Order Confirmation E-Mail", %q{
  In order to keep up to date with my orders
  As an artisan
  I want to receive an E-Mail when an order is paid for.
} do
  
  background do
    # Given there is a purchased order,
    create_purchased_order
  end
  
  scenario "An artisan receives an E-Mail when an order is paid for" do
    # Then the artisan should receive an E-Mail.
    ActionMailer::Base.deliveries.should_not be_empty

    email = ActionMailer::Base.deliveries[0]
    email.from.should    include 'noreply@artisanengine.com'
    email.to.should      include 'artisan@artisanengine.com'
    email.subject.should == 'You have received an order!'
    
    email.encoded.should =~ /Goods ordered:/
    email.encoded.should =~ /1x/
    email.encoded.should =~ /Cloak of No Particular Color/
    email.encoded.should =~ /Shipping Address/
    email.encoded.should =~ /You can view and manage this order's details/
  end
end