class CreateMonitorings < ActiveRecord::Migration
  def self.up
    create_table :monitorings do |t|
      t.integer :user_id, :null => false
      t.integer :department_id, :null => false
      t.string :monitorizable_type, :null => false
      t.integer :monitorizable_id, :null => false
      t.boolean :is_monitored
    end
    add_index :monitorings, :user_id
    add_index :monitorings, :department_id
    add_index :monitorings, :monitorizable_type
    add_index :monitorings, :monitorizable_id
  end

  def self.down
    drop_table :monitorings
  end
end
