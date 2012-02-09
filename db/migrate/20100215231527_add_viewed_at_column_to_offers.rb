class AddViewedAtColumnToOffers < ActiveRecord::Migration
  def self.up
    add_column :offers, :viewed_at, :datetime
  end

  def self.down
    remove_column :offers, :viewed_at
  end
end
