class CreateOfferings < ActiveRecord::Migration
  def self.up
    create_table :offerings do |t|
      t.integer  :offer_id
      t.integer  :plagg_id
      t.timestamps
    end
  end

  def self.down
    drop_table :offerings
  end
end
