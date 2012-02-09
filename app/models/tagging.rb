class Tagging < ActiveRecord::Base
  belongs_to :plagg
  belongs_to :tag

  validates_presence_of :plagg_id, :tag_id
end
