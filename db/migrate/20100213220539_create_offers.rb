class CreateOffers < ActiveRecord::Migration
  def self.up
    create_table :offers do |t|
      t.integer  :sender_id
      t.integer  :receiver_id
      t.integer  :plagg_id
      t.datetime :received_at
      t.datetime :sent_at
      t.timestamps
    end
  end

  def self.down
    drop_table :offers
  end
end
