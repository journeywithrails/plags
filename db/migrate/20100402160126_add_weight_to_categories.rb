class AddWeightToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :weight, :integer, :default => 0
  end

  def self.down
    remove_column :categories, :weight
  end
end
