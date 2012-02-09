class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string   :name
      t.integer  :department_id
      t.timestamps
    end

    add_column :plaggs, :category_id, :integer
  end

  def self.down
    remove_column :plaggs, :category_id
    drop_table :categories
  end
end
