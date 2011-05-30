class InstallAttachments < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.string    :name,            :null => false
      t.string    :image_file_uid,  :null => false
      t.string    :crop_values
      
      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
