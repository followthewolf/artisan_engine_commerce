class InstallCommerce < ActiveRecord::Migration
  
  def self.up
    create_table :orders do |t|
      t.integer   :patron_id
      t.string    :status,              :default => 'new',
                                        :null    => false
      t.integer   :shipping_address_id
      t.integer   :billing_address_id
      
      t.timestamps
    end
    
    create_table :order_transactions do |t|
      t.integer   :order_id,        :null    => false
      t.integer   :amount_in_cents, :default => 0,
                                    :null    => false
      t.string    :currency,        :null    => false
      t.boolean   :success,         :default => false
      t.string    :reference,       :null    => false
      t.string    :message,         :null    => false
      t.string    :action,          :null    => false
      t.string    :params
      t.boolean   :test,            :default => 0,
                                    :null    => false
      
      t.timestamps
    end

    create_table :adjustments do |t|
      t.integer   :order_id,        :null    => false
      t.integer   :line_item_id
      t.integer   :amount_in_cents, :default => 0,
                                    :null    => false
      t.string    :currency,        :null    => false
      t.string    :message,         :null    => false
      
      t.timestamps
    end
    
    create_table :line_items do |t|
      t.integer   :order_id,        :null    => false
      t.integer   :fulfillment_id
      t.string    :sku,             :null    => false
      t.string    :options
      t.integer   :price_in_cents,  :default => 0,
                                    :null    => false
      t.string    :currency,        :null    => false
      t.string    :name,            :null    => false
      t.integer   :quantity,        :default => 1,
                                    :null    => false
      
      t.timestamps
    end
    
    create_table :fulfillments do |t|
      t.integer   :order_id,      :null    => false
      t.integer   :cost_in_cents, :default => 0,
                                  :null    => false
      t.string    :currency,      :null    => false
      t.string    :tracking
    
      t.timestamps
    end
    
    create_table :patrons do |t|
      t.string    :first_name,  :null => false
      t.string    :last_name,   :null => false
      t.string    :email,       :null => false

      t.timestamps
    end
    
    create_table :addresses do |t|
      t.integer   :patron_id
      t.string    :first_name,  :null => false
      t.string    :last_name,   :null => false
      t.string    :address1,    :null => false
      t.string    :address2
      t.string    :country,     :null => false
      t.string    :city,        :null => false
      t.string    :state
      t.string    :postal_code, :null => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :orders
    drop_table :order_transactions
    drop_table :adjustments
    drop_table :line_items
    drop_table :patrons
    drop_table :addresses
  end
  
end
