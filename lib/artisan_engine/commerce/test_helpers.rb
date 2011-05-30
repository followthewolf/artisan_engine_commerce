module ArtisanEngine
  module Commerce
    module TestHelpers
      
      # --------------------------- Patrons ---------------------------- #
      
      Factory.sequence :patron_email do |e|
        "patron-#{e}@example.com"
      end
      
      Factory.define :patron do |p|
        p.first_name            { Forgery::Name.first_name }
        p.last_name             { Forgery::Name.last_name }
        p.email                 { Factory.next :patron_email }
      end
      
      # -------------------------- Addresses --------------------------- #
      
      Factory.define :address do |a|
        a.first_name  { Forgery::Name.first_name }
        a.last_name   { Forgery::Name.last_name }
        a.address1    { Forgery::Address.street_address }
        a.city        { Forgery::Address.city }
        a.postal_code { Forgery::Address.zip }
        a.country     { Forgery::Address.country }
      end
      
      # --------------------------- Orders ----------------------------- #
      
      Factory.define :order do |o|
      end
      
      Factory.define :pending_order, :parent => :order do |p|
        p.association :patron
        p.email       { Forgery::Internet.email_address }
        p.association :shipping_address, :factory => :address
        p.association :billing_address,  :factory => :address
        
        p.status      'pending'
      end
      
      module Integration
        
        # --------------------------- Orders ----------------------------- #
        
        def add_to_order( good_name, options = {} )
          # Visit the good page.
          good = Good.find_by_name( good_name )
          visit "/goods/#{ good.id }"
          
          # Select option values.
          options.each do |key, value|
            option_type  = key.to_s.titleize
            option_value = value
              
            select option_value, :from => option_type
          end
          
          # Add to order.
          click_button 'Add to Order'
        end
        
        def create_pending_order( checkout = true )          
          # Reset sessions.
          Capybara.reset_sessions!
          
          # Create a good unless one already exists.
          create_good_with_populated_option_types unless Good.any?
          
          # Create a variant unless one already exists.
          unless Good.find_by_name( 'Cloak of No Particular Color' ).variants.any?
            create_variant_for 'Cloak of No Particular Color', :values => { :size       => 'Medium', 
                                                                            :luminosity => 'Brilliant' }
          end
          
          # Add the variant to the order.
          add_to_order 'Cloak of No Particular Color', :size       => 'Medium', 
                                                       :luminosity => 'Brilliant'
          
          # Checkout the order.
          checkout_order if checkout
        end
        
        def checkout_order
          visit '/checkout'
          fill_in_valid_checkout_information
          click_button 'Pay with PayPal'
        end
        
        def create_purchased_order
          create_pending_order
          simulate_ipn
        end
        
        def fill_in_valid_checkout_information
          fill_in 'E-Mail',          :with => 'randy@skywalkersound.com'

          within '#shipping_address' do
            fill_in 'First Name',    :with => 'Randy'
            fill_in 'Last Name',     :with => 'Thom'
            fill_in 'Address 1',     :with => '1110 Gorgas Ave.'
            fill_in 'Address 2',     :with => ''
            fill_in 'City',          :with => 'San Francisco'
            fill_in 'Postal Code',   :with => '92530'

            select  'United States', :from => 'Country'
            fill_in 'State',         :with => 'CA'
            
            uncheck 'My billing address is the same as my shipping address.'
          end

          within '#billing_address' do
            fill_in 'First Name',    :with => 'George'
            fill_in 'Last Name',     :with => 'Lucas'
            fill_in 'Address 1',     :with => '1110 Gorgas Ave.'
            fill_in 'Address 2',     :with => ''
            fill_in 'City',          :with => 'San Francisco'
            fill_in 'Postal Code',   :with => '9253'

            select  'United States', :from => 'Country'
            fill_in 'State',         :with => 'CA'
          end
        end
        
        def simulate_ipn( options = {} )
          page.driver.post '/ipns', :txn_id         => options[ :ref ]      || 'TESTTRANS',
                                    :invoice        => options[ :order ]    || Order.last.id,
                                    :payment_status => options[ :status ]   || 'Completed',
                                    :settle_amount  => options[ :price ]    || Forgery::Monetary.money( :min => 1, :max => 500 ),
                                    :secret         => options[ :secret ]   || ArtisanEngine::Commerce::PaypalWPS.secret,
                                    :shipping       => options[ :shipping ] || 0,
                                    :tax            => options[ :tax ]      || 0
        end
        
        def fulfill_order( options = {} )
          visit "/manage/orders/#{ Order.last.id }"
        
          click_link 'Fulfill Items'
          
          for item in options[ :line_items ]
            check item
          end

          fill_in 'Cost',     :with => 25
          fill_in 'Tracking', :with => 'ABC123'

          click_button 'Fulfill'
        end
          
      end
    end
  end
end