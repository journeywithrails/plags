class CreateDepartments < ActiveRecord::Migration
  def self.up
    create_table :departments do |t|
      t.string   :name
      t.timestamps
    end
    
    add_column :plaggs, :department_id, :integer
  end

  def self.down
    remove_column :plaggs, :department_id
    drop_table :departments
  end
end
