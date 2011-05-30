class InstallAttachability < ActiveRecord::Migration
  
  def self.up
    create_table :attachers do |t|
      t.references :attachment, :polymorphic => true
      t.references :attachable, :polymorphic => true
      t.integer    :position,   :null => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :attachers
  end
  
end
