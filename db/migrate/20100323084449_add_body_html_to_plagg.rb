class AddBodyHtmlToPlagg < ActiveRecord::Migration
  def self.up
     add_column :plaggs, :body_html, :text
  end

  def self.down
     remove_column :plaggs, :body_html
  end
end
