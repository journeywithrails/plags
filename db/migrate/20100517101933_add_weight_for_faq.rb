class AddWeightForFaq < ActiveRecord::Migration
  def self.up
    add_column :contents, :weight, :int
  end

  def self.down
    remove_column :contents, :weight
  end
end
