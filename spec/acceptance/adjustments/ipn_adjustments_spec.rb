require File.expand_path( '../../acceptance_helper', __FILE__ )

feature "Order Adjustments from IPNs", %q{
  In order to keep track of tax and shipping charges from PayPal WPS
  As an artisan
  I want order adjustments to be created when I receive an IPN.
} do
  
  background do
    # Given I have a pending order,
    create_pending_order
    
    # And I receive an IPN with tax and shipping costs,
    simulate_ipn :shipping => 25,
                 :tax      => 5
  end
  
  scenario "IPNs create order adjustments from tax and shipping" do
    # When I visit the order details page for the order,
    visit "/manage/orders/#{ Order.last.id }"
    
    # Then I should see shipping costs for $25.00,
    within '.adjustment', :text => 'PayPal-Calculated Shipping' do
      page.should have_content "$25.00"
    end
    
    # And I should see tax of $5.00.
    within '.adjustment', :text => 'PayPal-Calculated Tax' do
      page.should have_content "$5.00"
    end
  end
end