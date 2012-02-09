class MakeFbUserIdABigint < ActiveRecord::Migration
  def self.up
    change_column :users, :fb_user_id, :integer, :limit => 8
  end

  def self.down
    change_column :users, :fb_user_id, :integer, :limit => 4
  end
end
