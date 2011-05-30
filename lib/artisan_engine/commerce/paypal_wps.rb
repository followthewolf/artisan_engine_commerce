module ArtisanEngine
  module Commerce
    module PaypalWPS
      
      mattr_accessor :secret
      @@secret = 'onelefts7anding'
      
      mattr_accessor :paypal_url
      @@paypal_url = "https://www.sandbox.paypal.com/cgi_bin/webscr?"
      
      mattr_accessor :seller_email
      @@seller_email = 'seller_1306290307_biz@followthewolf.com'

      mattr_accessor :return_url
      @@return_url = 'http://artisanengine.com/orders'

      mattr_accessor :notify_url
      @@notify_url = "http://artisanengine.com/payment_notifications?secret=#{ ArtisanEngine::Commerce::PaypalWPS.secret }"
      
      mattr_accessor :paypal_certificate_id
      @@paypal_certificate_id = '8XWLPQF9JKCRQ'
      
      mattr_accessor :paypal_certificate
      @@paypal_certificate = File.read( File.expand_path '../test_certificates/paypal_cert.pem', __FILE__ )
      
      mattr_accessor :application_certificate
      @@application_certificate = File.read( File.expand_path '../test_certificates/app_cert.pem', __FILE__ )
      
      mattr_accessor :application_key
      @@application_key = File.read( File.expand_path '../test_certificates/app_key.pem', __FILE__ )
  
    end
  end
end