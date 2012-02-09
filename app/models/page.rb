require 'rdiscount'

class Page < ActiveRecord::Base
  attr_protected :user_id

  has_many :comments, :as => :commentable

  belongs_to :user

  validates_presence_of :title, :content, :user_id

  before_save :generate_slug

  def content_html
    RDiscount.new(content).to_html
  end

  protected

  def generate_slug
    self.slug = title.downcase.strip.gsub(/\s+/, "-").gsub(/[^a-z0-9\-_]/, "") if self.slug.blank?
  end
end
