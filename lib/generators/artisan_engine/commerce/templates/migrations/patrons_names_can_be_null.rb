class PatronsNamesCanBeNull < ActiveRecord::Migration
  def self.up
    change_column :patrons, :first_name, :string, :null => true
    change_column :patrons, :last_name, :string, :null => true
  end
  
  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end