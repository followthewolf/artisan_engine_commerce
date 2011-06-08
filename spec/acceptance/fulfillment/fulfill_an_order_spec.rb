require File.expand_path( '../../acceptance_helper', __FILE__ )

feature "Fulfill an Order", %q{
  In order to manage shipping and other fulfillment logistics for my orders
  As an artisan
  I want to fulfill an order.
} do
  
  background do
    # Given there is a paid order,
    create_purchased_order
    
    # And I am on the order's detail page,
    visit "/manage/orders/#{ Order.last.id }"
  end
  
  scenario "I can fulfill an order" do
    # When I click the Fulfill Items button,
    click_link 'Fulfill Items'
    
    # And I check the line item,
    check 'Cloak of No Particular Color'
    
    # And I fill in my shipping method, tracking number, and cost and click Fulfill,
    fill_in 'Shipping Method', :with => 'UPS 3-Day'
    fill_in 'Cost',            :with => 25
    fill_in 'Tracking',        :with => 'ABC123'
    
    click_button 'Fulfill'
    
    # Then I should see my order fulfilled.
    page.should have_content 'Fulfilled'
    
    # And the patron should receive an E-Mail.
    ActionMailer::Base.deliveries.should_not be_empty
    
    email = ActionMailer::Base.deliveries[0]
    email.from.should    include 'noreply@artisanengine.com'
    email.to.should      include 'randy@skywalkersound.com'
    email.subject.should == 'Your order has shipped!'
    email.encoded.should =~ /The following items from your order have shipped:/
    email.encoded.should =~ /1x/
    email.encoded.should =~ /Cloak of No Particular Color/
    email.encoded.should =~ /Thank you/
  end
end