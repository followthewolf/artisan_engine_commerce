require File.expand_path( '../../acceptance_helper', __FILE__ )

feature "Receive PayPal IPNs", %q{
  In order to be notified when patrons pay using PayPal Website Payments Standard
  As an artisan
  I want my order to update when my site receives an Instant Payment Notification.
} do
  
  background do
    # Given I have a pending order,
    create_pending_order
  end
  
  scenario "Valid IPNs update order status" do
    # When my site receives an IPN,
    simulate_ipn
    
    # Then when I visit the manage orders page,
    visit '/manage/orders'
    
    # And I should see a Purchased order.
    page.should have_selector '.order .status', :text => 'purchased'
  end
    
  scenario "Invalid IPNs do not update order status" do
    # When my site receives an invalid IPN,
    simulate_ipn :status => 'Incomplete.'

    # Then when I visit the manage orders page,
    visit '/manage/orders'
    
    # And I should see a Pending order.
    page.should have_selector '.order .status', :text => 'pending'
  end
end