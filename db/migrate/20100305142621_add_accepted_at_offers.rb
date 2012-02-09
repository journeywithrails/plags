class AddAcceptedAtOffers < ActiveRecord::Migration
  def self.up
    add_column :offers, :accepted_at, :datetime
  end

  def self.down
      remove_column :offers, :accepted_at
  end
end
