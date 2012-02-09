class AddNotesToOfferings < ActiveRecord::Migration
  def self.up
     add_column :offerings, :notes, :string
  end

  def self.down
     remove_column :offerings, :notes
  end
end
