class Size < ActiveRecord::Base
  has_many :plaggs
  has_many :sizings, :dependent => :destroy
  has_many :categories, :through => :sizings
  has_many :monitorings, :as => :monitorizable

  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
end
