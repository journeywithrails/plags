class AddWeightToDepartmentsColumn < ActiveRecord::Migration
  def self.up
    add_column :departments, :weight, :integer, :default => 0
  end

  def self.down
    remove_column :departments, :weight
  end
end
