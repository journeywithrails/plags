class CreatePlaggs < ActiveRecord::Migration
  def self.up
    create_table :plaggs do |t|
      t.string   :title
      t.text     :description
      t.string   :price
      t.boolean  :is_tradeable
      t.timestamps
    end
  end

  def self.down
    drop_table :plaggs
  end
end
