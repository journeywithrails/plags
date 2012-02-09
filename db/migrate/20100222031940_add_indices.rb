class AddIndices < ActiveRecord::Migration
  def self.up
    add_index :users,      :email_address
    add_index :categories, :department_id
    add_index :plaggs,     :department_id
    add_index :plaggs,     :category_id
    add_index :plaggs,     :size_id
    add_index :taggings,   :tag_id
    add_index :taggings,   :plagg_id
    add_index :sizings,    :category_id
    add_index :sizings,    :size_id
    add_index :offers,     [ :sender_id, :sent_at ]
    add_index :offers,     [ :receiver_id, :received_at ]
    add_index :watchings,  :watcher_id
    add_index :comments,   [ :commentable_id, :commentable_type ]
  end

  def self.down
    remove_index :users,      :email_address
    remove_index :categories, :department_id
    remove_index :plaggs,     :department_id
    remove_index :plaggs,     :category_id
    remove_index :plaggs,     :size_id
    remove_index :taggings,   :tag_id
    remove_index :taggings,   :plagg_id
    remove_index :sizings,    :category_id
    remove_index :sizings,    :size_id
    remove_index :offers,     [ :sender_id, :sent_at ]
    remove_index :offers,     [ :receiver_id, :received_at ]
    remove_index :watchings,  :watcher_id
    remove_index :comments,   [ :commentable_id, :commentable_type ]
  end
end
