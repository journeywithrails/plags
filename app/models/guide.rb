require 'rdiscount'

class Guide < ActiveRecord::Base
  attr_protected :user_id

  has_many :comments, :as => :commentable
  has_attached_file :image, :styles => { :normal=> "210x260>" }, 
    :default_style => :normal,
    :path => ":rails_root/public/images/guide/:style/:id/:filename",
    :url => "/images/guide/:style/:id/:filename"

  belongs_to :user

  validates_presence_of :title, :content, :user_id
  validates_attachment_size :image, :less_than => 5.megabytes  
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/pjpeg']  

  def content_html
    RDiscount.new(content).to_html
  end
end
