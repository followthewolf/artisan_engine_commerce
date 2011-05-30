require File.expand_path( '../../../acceptance_helper', __FILE__ )

feature "View An Order's Details", %q{
  In order to view and manage my orders
  As an artisan
  I want to see an order's details.
} do
  
  background do
    # Given there is a purchased order,
    create_purchased_order
    
    # And I am on the manage orders page,
    visit '/manage/orders'
  end
  
  scenario "I can view an order's details" do
    order = Order.last
    
    # When I click the order's Details link,
    within '.order' do
      click_link 'Details'
    end
    
    # Then I should see the status of the order,
    page.should have_content 'Purchased'
    
    # And I should see the buyer's first name, last name, and E-Mail,
    patron = order.patron
    
    page.should have_content "#{ patron.first_name } #{ patron.last_name }"
    page.should have_content patron.email
    
    # And I should see the buyer's shipping information
    shipping_address = order.shipping_address
    
    page.should have_content 'Shipping Address'
    page.should have_content shipping_address.address1
    page.should have_content shipping_address.city
    page.should have_content shipping_address.postal_code
    
    # And I should see the buyer's billing information
    billing_address = order.billing_address
    
    page.should have_content 'Billing Address'
    page.should have_content billing_address.address1
    page.should have_content billing_address.city
    page.should have_content billing_address.postal_code
    
    # And I should see the line items in the order with their prices and quantities.
    line_item = order.line_items.first
    
    page.should have_selector '.line_item'
    page.should have_selector '.price',    :text => line_item.price.to_s
    page.should have_selector '.quantity', :text => line_item.quantity.to_s
  end
end