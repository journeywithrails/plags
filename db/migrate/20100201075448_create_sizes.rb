class CreateSizes < ActiveRecord::Migration
  def self.up
    create_table :sizes do |t|
      t.string :name
      t.timestamps
    end

    add_column :plaggs, :size_id, :integer
  end

  def self.down
    remove_column :plaggs, :size_id
    drop_table :sizes
  end
end
