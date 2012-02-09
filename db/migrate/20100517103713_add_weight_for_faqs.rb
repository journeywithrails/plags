class AddWeightForFaqs < ActiveRecord::Migration
  def self.up
    add_column :contents, :weight, :int, :default=>0
  end

  def self.down
     remove_column :contents, :weight
  end
end
