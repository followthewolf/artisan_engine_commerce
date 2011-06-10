class AddSubscribedToPatrons < ActiveRecord::Migration
  def self.up
    add_column :patrons, :subscribed, :boolean, :default => false
  end

  def self.down
    remove_column :patrons, :subscribed
  end
end
