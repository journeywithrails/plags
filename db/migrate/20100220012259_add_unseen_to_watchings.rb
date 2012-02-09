class AddUnseenToWatchings < ActiveRecord::Migration
  def self.up
    add_column :watchings, :current_unseen, :integer
    add_column :watchings, :new_unseen, :integer
  end

  def self.down
    remove_column :watchings, :current_unseen
    remove_column :watchings, :new_unseen
  end
end
