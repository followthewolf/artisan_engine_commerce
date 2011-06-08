require 'artisan_engine/catalog'
require 'state_machine'
require 'carmen'
require 'artisan_engine/commerce'

module ArtisanEngine
  module Commerce
    
    mattr_accessor :from_email
    @@from_email = 'noreply@artisanengine.com'
    
    mattr_accessor :artisan_email
    @@artisan_email = 'artisan@artisanengine.com'
    
    mattr_accessor :domain
    @@domain = 'artisanengine.com'
  
    # ------------------ Autoload Necessary Modules ------------------ #
    
    autoload :TestHelpers, 'artisan_engine/commerce/test_helpers' if Rails.env.test?
    autoload :PaypalWPS,   'artisan_engine/commerce/paypal_wps'
    
    # ------------------------- Vroom vroom! ------------------------- #
    
    class Engine < Rails::Engine
      config.before_configuration do
        ActionView::Helpers::AssetTagHelper.register_stylesheet_expansion :artisan_engine       => [ "artisan_engine/commerce/back" ],
                                                                          :artisan_engine_front => [ "artisan_engine/commerce/front" ]
      end
      
      initializer 'include helpers' do
        ActiveSupport.on_load( :action_controller ) { include OrdersHelper }
        ActiveSupport.on_load( :action_view )       { include OrdersHelper }
      end
      
      config.to_prepare do
        Carmen.excluded_states = { 'US' => [ 'AA', 'AE', 'AP' ] }
      end
    end

  end
end