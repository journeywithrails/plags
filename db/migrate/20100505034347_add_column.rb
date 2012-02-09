class AddColumn < ActiveRecord::Migration
  def self.up
    add_column :plaggs, :brand_name, :string
  end

  def self.down
    remove_column :plaggs, :brand_name, :string
  end
end
