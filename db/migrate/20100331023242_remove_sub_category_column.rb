class RemoveSubCategoryColumn < ActiveRecord::Migration
  def self.up
    remove_column :categories, :sub_category
  end

  def self.down
    add_column :categories, :sub_category, :boolean
	Category.update_all("sub_category = false")
  end
end
