class Sizing < ActiveRecord::Base
  belongs_to :category
  belongs_to :size

  validates_presence_of :category_id, :size_id
end
