class CreateNetworksUsers < ActiveRecord::Migration
  def self.up
    create_table :networks_users do |t|
        t.integer :user_id
        t.integer :network_id
        t.string  :url
        t.timestamps
     end
  end

  def self.down
    drop_table :networks_users
  end
end
