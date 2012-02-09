class AddBodyToPlaggs < ActiveRecord::Migration
  def self.up
    add_column :plaggs, :body, :string
  end

  def self.down
    remove_column :plaggs, :body
  end
end
