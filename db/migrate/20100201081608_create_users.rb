class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string   :username
      t.string   :email_address
      t.string   :password_hash
      t.integer  :role
      t.integer  :gender
      t.text     :profile
      t.string   :phone_number
      t.string   :county
      t.string   :city
      t.timestamps
    end

    add_column :plaggs, :user_id, :integer
  end

  def self.down
    remove_column :plaggs, :user_id
    drop_table :users
  end
end
