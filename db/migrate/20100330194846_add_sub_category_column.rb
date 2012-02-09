class AddSubCategoryColumn < ActiveRecord::Migration
  def self.up
    add_column :categories, :sub_category, :boolean
	Category.update_all("sub_category = false")
  end

  def self.down
    remove_column :categories, :sub_category
  end
end
