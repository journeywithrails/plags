class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer  :user_id
      t.text     :text
      t.references :commentable, :polymorphic => true
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
