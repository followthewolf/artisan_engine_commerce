class Order < ActiveRecord::Base
  attr_accessor                 :email
  
  has_many                      :line_items
  has_many                      :adjustments
  has_many                      :fulfillments
  belongs_to                    :patron

  belongs_to                    :shipping_address, :class_name => 'Address'
  validates_associated          :shipping_address
  
  belongs_to                    :billing_address,  :class_name => 'Address'
  validates_associated          :billing_address
  
  # ------------------------ State Machine ------------------------- #
  
  state_machine :status, :initial => :new do
    state :new
    
    event :checkout! do
      transition :new     => :pending
      transition :pending => :pending
    end
    
    state :pending do
      validates_presence_of :email, :shipping_address, :billing_address
    end
    
    after_transition :new => :pending,     :do => :set_patron
    after_transition :pending => :pending, :do => :set_patron

    state :purchased
    
    event :purchase! do
      transition :pending => :purchased
    end
  end
  
  # ----------------------- Instance Methods ----------------------- #
  
  def new_line_item_from( variant = nil )
    variant ? add_line_item_to_order( variant ) : line_items.build
  end
    
  def line_item_exists?( variant )
    line_items.where( :sku => variant.sku ).first
  end
  
  def set_patron
    self.patron = Patron.find_or_create_by_email( :email      => email, 
                                                  :first_name => billing_address.first_name, 
                                                  :last_name  => billing_address.last_name )
    save
  end
  
  def unfulfilled_line_items
    line_items.where( :fulfillment_id => nil ).all
  end
  
  def fulfillment_status
    unfulfilled_items = line_items.where( :fulfillment_id => nil ).all
    unfulfilled_count = unfulfilled_items.count
    
    return 'Fulfilled'           if unfulfilled_count.zero?
    return 'Not Fulfilled'       if unfulfilled_count == line_items.count
    return 'Partially Fulfilled'
  end
  
  # ------------------- Address Setter Overrides ------------------- #
  
  def shipping_address=( address )
    return unless address
       
    duplicate_address = Address.where( :first_name => address.first_name,
                                       :last_name  => address.last_name ).first
                   
    if duplicate_address
      self.shipping_address_id = duplicate_address.id
    else
      address.save
      self.shipping_address_id = address.id
    end
  end
  
  def billing_address=( address )   
    return unless address
    
    duplicate_address = Address.where( :first_name => address.first_name,
                                       :last_name  => address.last_name ).first
                   
    if duplicate_address
      self.billing_address_id = duplicate_address.id
    else
      address.save
      self.billing_address_id = address.id
    end
  end
  
  def total
    total = Money.new( 0, "USD" )
    
    for line_item in line_items
      total += ( line_item.price * line_item.quantity )
    end
    
    for adjustment in adjustments
      total += ( adjustment.amount )
    end
    
    total
  end
  
  # --------------------------- PayPal ----------------------------- #
  
  def to_paypal
    values = {
      :business   => ArtisanEngine::Commerce::PaypalWPS.seller_email,
      :invoice    => id,
      :cmd        => '_cart',
      :upload     => 1,
      :return     => ArtisanEngine::Commerce::PaypalWPS.return_url,
      :notify_url => ArtisanEngine::Commerce::PaypalWPS.notify_url,
      :cert_id    => ArtisanEngine::Commerce::PaypalWPS.paypal_certificate_id
    }
    
    line_items.each_with_index do |item, index|
      values.merge!({
        "amount_#{ index + 1 }"    => item.price,
        "item_name_#{ index + 1 }" => item.name + " (#{ item.options })",
        "quantity_#{ index + 1 }"  => item.quantity
      })
    end
    
    encrypt_for_paypal( values )
  end
  
  # ------------------ Private Instance Methods -------------------- #
  
  private
    
    # Return a new line item if no duplicates exist. Otherwise, return the duplicate line item with new quantity.
    def add_line_item_to_order( variant )
      duplicate_line_item           = line_item_exists?( variant )
      duplicate_line_item.quantity += 1 and return duplicate_line_item if duplicate_line_item

      line_items.build :name    => variant.good.name, 
                       :price   => variant.price, 
                       :options => variant.option_values_to_s,
                       :sku     => variant.sku
    end
    
    def encrypt_for_paypal( values )
      app_cert    = ArtisanEngine::Commerce::PaypalWPS.application_certificate
      app_key     = ArtisanEngine::Commerce::PaypalWPS.application_key
      paypal_cert = ArtisanEngine::Commerce::PaypalWPS.paypal_certificate
      
      signed = OpenSSL::PKCS7::sign( OpenSSL::X509::Certificate.new( app_cert ), 
                                     OpenSSL::PKey::RSA.new( app_key, '' ), 
                                     values.map { |k, v| "#{ k }=#{ v }" }.join("\n"), 
                                     [], 
                                     OpenSSL::PKCS7::BINARY )  
                                     
      OpenSSL::PKCS7::encrypt( [ OpenSSL::X509::Certificate.new( paypal_cert ) ], 
                                 signed.to_der, 
                                 OpenSSL::Cipher::Cipher::new( "DES3" ), 
                                 OpenSSL::PKCS7::BINARY ).to_s.gsub( "\n", "" )
    end
end