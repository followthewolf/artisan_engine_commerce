class InstallArtisanEngineCatalog < ActiveRecord::Migration
  def self.up
    
    # ----------------------------- Goods ---------------------------- #
    
    create_table :goods do |t|
      t.string    :name,            :null => false
      t.text      :description

      t.timestamps
    end
    
    # Install FriendlyID for Goods.
    add_column :goods, :cached_slug, :string
    add_index  :goods, :cached_slug, :unique => true

    # ---------------------------- Variants -------------------------- #
    
    create_table :variants do |t|
      t.integer   :good_id,         :null       => false
      t.boolean   :is_master,       :default    => false
      t.string    :sku,             :null       => false
      
      t.integer   :price_in_cents,  :default    => 0,
                                    :null       => false
      t.string    :currency,        :null       => false

      t.timestamps
    end
    
    add_index :variants, :sku, :unique => true
    
    # ------------------------- Option Types ------------------------- #
    
    create_table :option_types do |t|
      t.string    :name,            :null => false
      t.integer   :position,        :null => false
      
      t.timestamps
    end

    # ------------------------- Option Values ------------------------ #

    create_table :option_values do |t|
      t.integer   :option_type_id,  :null => false
      t.string    :name,            :null => false
      t.integer   :position,        :null => false
      
      t.timestamps
    end

    # -------------------------- Join Tables ------------------------- #
    
    create_table :goods_option_types, :id => false do |t|
      t.integer   :good_id,         :null => false
      t.integer   :option_type_id,  :null => false
    end

    create_table :option_values_variants, :id => false do |t|
      t.integer   :option_value_id, :null => false
      t.integer   :variant_id,      :null => false
    end
  end

  def self.down
    drop_table    :goods
    drop_table    :variants
    drop_table    :option_types
    drop_table    :option_values
    drop_table    :goods_option_types
    drop_table    :option_values_variants
  end
end
