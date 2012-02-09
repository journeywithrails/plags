class Offer < ActiveRecord::Base
  has_many :offerings, :dependent => :destroy
  has_many :plaggs,    :through => :offerings

  belongs_to :sender,   :class_name => "User"
  belongs_to :receiver, :class_name => "User"
  belongs_to :plagg

  validates_presence_of :plagg_id
end
