class AddCategorizableToMonitorings < ActiveRecord::Migration
  def self.up
    add_column :monitorings, :categorizable_id, :integer
    add_column :monitorings, :categorizable_type, :string
    add_index :monitorings, :categorizable_id
    add_index :monitorings, :categorizable_type
  end

  def self.down
    remove_column :monitorings, :categorizable_id
    remove_column :monitorings, :categorizable_type
    add_column :monitorings, :department_id, :integer
  end
end
