class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.column :title, :string
      t.column :description, :text
      t.column :status, :tinyint
      t.timestamps
    end
  end

  def self.down
    drop_table :contents
  end
end
