require File.expand_path( '../../acceptance_helper', __FILE__ )

feature "Checkout", %q{
  In order to begin the purchase process
  As a patron
  I want to check out.
} do
  
  background do
    # Given a good exists,
    create_good :name => 'Gnarlystick'
    
    # And I have added the good to my order,
    add_to_order 'Gnarlystick'
    
    # And I have clicked the 'Checkout' link,
    click_link 'Checkout'
  end
  
  scenario "I can check out an order with valid information" do
    # When I fill in valid checkout information,
    fill_in_valid_checkout_information
    
    # And I click Pay with PayPal,
    click_button 'Pay with PayPal'
    
    # Then there should be one pending order.
    Order.first.status.should == 'pending'
    
    # And when I click the Continue to PayPal button,
    click_button 'Continue to PayPal'

    # Then I should be redirected to PayPal.
    page.should have_content 'Welcome to PayPal!'
  end
  
  scenario "I cannot check out an order with invalid information" do
    # When I fill in invalid checkout information,
    fill_in 'E-Mail',          :with => 'randy@skywalkersound.com'
    
    within '#shipping_address' do
      fill_in 'Address 1',     :with => '1110 Gorgas Ave.'
      fill_in 'Address 2',     :with => ''
      fill_in 'City',          :with => 'San Francisco'
      fill_in 'Postal Code',   :with => '9253'
    
      select  'United States', :from => 'Country'
      fill_in 'State',         :with => 'CA'
    end
    
    # And I click Pay with PayPal,
    click_button 'Pay with PayPal'

    # Then I should see an alert,
    page.should have_selector '.alert'
    
    # And there should still be one new order.
    Order.first.status.should == 'new'
  end
end