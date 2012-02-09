class CreateGuides < ActiveRecord::Migration
  def self.up
    create_table :guides do |t|
      t.string   :title
      t.text     :content
      t.integer  :user_id
      t.string   :image_file_name # Original filename
      t.string   :image_content_type # Mime type
      t.integer  :image_file_size # File size in bytes
      t.timestamps
    end
  end

  def self.down
    drop_table :guides
  end
end
