require File.expand_path( '../../acceptance_helper', __FILE__ )

feature "Add a Line Item with Options to an Order", %q{
  In order to choose multiple variations of the items I want to buy
  As a patron
  I want to add a line item with options to my order.
} do
  
  background do
    # Given there is a good with option types,
    create_good_with_populated_option_types
    
    # And it has a variant,
    create_variant_for 'Cloak of No Particular Color', :price => 235,
                                                       :values => { :size       => 'Large', 
                                                                    :luminosity => 'Blinding' }
    
    # And I add the variant to my order,
    add_to_order 'Cloak of No Particular Color', :size       => 'Large',
                                                 :luminosity => 'Blinding'
  end
  
  scenario "I can add a line item with options to my order" do
    # Then I should see a line item with:
    within '.line_item' do
      # The good's name,
      page.should have_content 'Cloak of No Particular Color'
    
      # The good's variation's price,
      page.should have_content '$235.00'
      
      # A list of the variation's attrbutes,
      page.should have_content 'Size: Large / Luminosity: Blinding'
      
      # A quantity of 1.
      page.should have_selector '.quantity', :text => '1'
    end
  end
end