class AddShippingMethodToFulfillments < ActiveRecord::Migration
  def self.up
    add_column :fulfillments, :shipping_method, :string
  end

  def self.down
    remove_column :fulfillments, :shipping_method
  end
end
