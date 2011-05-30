require File.expand_path( '../../acceptance_helper', __FILE__ )

feature "Auto-Redirect to PayPal", %q{
  In order to pay for my order
  As a patron
  I want to be redirect to PayPal.
} do
  
  background do
    # Given I have populated an order,
    create_pending_order( false )
    
    # And I am checking out with valid information,
    visit '/checkout'
    
    fill_in 'E-Mail',          :with => 'randy@skywalkersound.com'

    within '#shipping_address' do
      fill_in 'First Name',    :with => 'Randy'
      fill_in 'Last Name',     :with => 'Thom'
      fill_in 'Address 1',     :with => '1110 Gorgas Ave.'
      fill_in 'Address 2',     :with => ''
      fill_in 'City',          :with => 'San Francisco'
      fill_in 'Postal Code',   :with => '92530'

      select 'United States', :from => 'Country'
      select 'California',    :from => 'State / Province'
      
      check 'My billing address is the same as my shipping address.'
    end
    
    click_button 'Pay with PayPal'
  end

  scenario "I am auto-redirected to PayPal if JavaScript is enabled", :js => true do
    # Then I should be redirected to PayPal.
    sleep 5 and page.current_url.should =~ /paypal/
  end
end