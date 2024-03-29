class CreateWatchings < ActiveRecord::Migration
  def self.up
    create_table :watchings do |t|
      t.integer  :watcher_id
      t.references :watchable, :polymorphic => true
      t.timestamps
    end
  end

  def self.down
    drop_table :watchings
  end
end
