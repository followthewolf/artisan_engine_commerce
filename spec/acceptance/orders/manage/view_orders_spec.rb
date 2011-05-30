require File.expand_path( '../../../acceptance_helper', __FILE__ )

feature "View My Orders", %q{
  In order to view and manage my orders
  As an artisan
  I want to see all my orders.
} do
  
  background do
    # Given I have three pending orders,
    3.times { create_pending_order }
  
    # And I am on the manage orders page,
    visit '/manage/orders'
  end
  
  scenario "I can see all my orders" do
    # Then I should see three orders,
    page.should have_selector '.order', :count => 3
    
    # And they should all be pending.
    page.should have_selector '.order .status', :text => 'Pending', :count => 3
  end
end