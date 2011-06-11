class UseHasManyThrough < ActiveRecord::Migration
  def self.up
    add_column :goods_option_types, :id, :primary_key
    add_column :option_values_variants, :id, :primary_key
  end
  
  def self.down
    remove_column :goods_option_types, :id, :primary_key
    remove_column :option_values_variants, :id, :primary_key
  end
end