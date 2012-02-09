class Offering < ActiveRecord::Base
  belongs_to :offer
  belongs_to :plagg

  validates_presence_of :offer_id, :plagg_id
end
