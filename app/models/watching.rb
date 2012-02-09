class Watching < ActiveRecord::Base
  belongs_to :watcher, :class_name => "User"
  belongs_to :watchable, :polymorphic => true
  belongs_to :category, :class_name => "Category",
                        :foreign_key => "watchable_id"
  belongs_to :department, :class_name => "Department",
                        :foreign_key => "watchable_id"
  belongs_to :watchee,  :class_name => "User",
                        :foreign_key => "watchable_id"

  validates_uniqueness_of :watcher_id, :scope => [ :watchable_id, :watchable_type ]
end
