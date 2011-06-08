require File.expand_path( '../../acceptance_helper', __FILE__ )

feature "Order Confirmation E-Mail", %q{
  In order to confirm that my order was paid for
  As a patron
  I want to receive an E-Mail when I pay for an order.
} do
  
  background do
    ActionMailer::Base.deliveries.clear
    
    # Given there is a purchased order,
    create_purchased_order
  end
  
  scenario "A patron receives an E-Mail when an order is paid for" do
    # Then the patron should receive an E-Mail.
    ActionMailer::Base.deliveries.should_not be_empty

    email = ActionMailer::Base.deliveries[1]
    email.from.should    include 'noreply@artisanengine.com'
    email.to.should      include 'randy@skywalkersound.com'
    email.subject.should == 'Thank you for your order!'
    
    email.encoded.should =~ /We have received payment for the following items/
    email.encoded.should =~ /1x/
    email.encoded.should =~ /Cloak of No Particular Color/
    email.encoded.should =~ /You will receive a confirmation when your items ship/
  end
end