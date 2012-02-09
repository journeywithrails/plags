class AddForgotpassword < ActiveRecord::Migration
  def self.up
     add_column :users, :security_token, :string
  end

  def self.down 
    remove_column :users, :security_token, :string
  end
end
