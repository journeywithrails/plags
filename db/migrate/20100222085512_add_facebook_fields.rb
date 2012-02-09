class AddFacebookFields < ActiveRecord::Migration
  def self.up
    add_column :users, :fb_user_id, :integer
    add_column :users, :fb_email_hash, :string
  end

  def self.down
    remove_column :users, :fb_user_id, :integer
    remove_column :users, :fb_email_hash, :string
  end
end
