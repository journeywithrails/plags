class Category < ActiveRecord::Base
  has_many :sizings,   :dependent => :destroy
  has_many :sizes,     :through => :sizings
  has_many :plaggs
  has_many :watchings, :as => :watchable, :dependent => :destroy
  has_many :watchers,  :through => :watchings

  belongs_to :department

  validates_presence_of :name, :department_id
  validates_numericality_of :weight, :only_integer => true
  validates_inclusion_of :weight, :in => -100..100, :message => 'must be between -100 to 100'
end
