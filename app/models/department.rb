class Department < ActiveRecord::Base
  default_scope :order => 'weight DESC'

  has_many :categories, :order => 'weight DESC', :dependent => :destroy
  has_many :plaggs
  has_many :monitorings

  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
  validates_numericality_of :weight, :only_integer => true
  validates_inclusion_of :weight, :in => -100..100, :message => 'must be between -100 to 100'
end
