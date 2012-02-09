class AddVideo < ActiveRecord::Migration
  def self.up
    add_column :posts, :body, :string
    add_column :posts, :body_html, :text
  end

  def self.down
    remove_column :posts, :body
    remove_column :posts, :body_html
  end
end
