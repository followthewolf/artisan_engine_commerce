require File.expand_path( '../../acceptance_helper', __FILE__ )

feature "Order Reset", %q{
  In order to begin a new purchase process
  As a patron
  I want to be assigned a new order once I have paid for my old one.
} do
  
  background do
    # Given I have completed and paid for my order,
    create_purchased_order
  end

  scenario "I am assigned a new order once I have paid for my old one" do    
    # When I visit my new order page,
    visit '/order'

    # Then I should see no line items.
    page.should have_no_selector '.line_item'
  end
end