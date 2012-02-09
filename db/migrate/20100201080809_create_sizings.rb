class CreateSizings < ActiveRecord::Migration
  def self.up
    create_table :sizings do |t|
      t.integer :category_id
      t.integer :size_id
      t.timestamps
    end
  end

  def self.down
    drop_table :sizings
  end
end
