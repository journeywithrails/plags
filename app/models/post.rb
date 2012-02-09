require 'rdiscount'

class Post < ActiveRecord::Base
  attr_protected :user_id

  has_many :comments, :as => :commentable
  has_attached_file :image, :styles => { :zoom => "600x940#", :preview => "300x470#", :miniview => "48x48#", :tile => "135x235!"}, 
    :default_style => :normal,
    :path => ":rails_root/public/images/blog/:style/:id/:filename",
    :url => "/images/blog/:style/:id/:filename"
    
    has_attached_file :image_2, :styles => { :zoom => "600x940#", :preview => "300x470#", :miniview => "48x48#", :tile => "135x235!"}, 
    :default_style => :normal,
    :path => ":rails_root/public/images/blog/:style/:id/:filename",
    :url => "/images/blog/:style/:id/:filename"
    
    has_attached_file :image_3, :styles => { :zoom => "600x940#", :preview => "300x470#", :miniview => "48x48#", :tile => "135x235!"}, 
    :default_style => :normal,
    :path => ":rails_root/public/images/blog/:style/:id/:filename",
    :url => "/images/blog/:style/:id/:filename"   
    
    

  belongs_to :user
  validates_format_of :body, :with =>/((http|https):\/\/)?(www\.)?(youtube\.com\/watch\?|vimeo\.com\/)()?([a-zA-Z0-9\-\.]+)\/?/i, :allow_blank=>true
  validates_presence_of :title, :content, :user_id
  validates_attachment_size :image, :less_than => 5.megabytes  
  validates_attachment_size :image_2, :less_than => 5.megabytes  
  validates_attachment_size :image_3, :less_than => 5.megabytes  
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/pjpeg']  
  validates_attachment_content_type :image_2, :content_type => ['image/jpeg', 'image/png', 'image/pjpeg'] 
  validates_attachment_content_type :image_3, :content_type => ['image/jpeg', 'image/png', 'image/pjpeg'] 
 
   has_permalink :title, :perma_link 
   
   
  def content_html
    RDiscount.new(content).to_html
  end
  
  
  
  
     auto_html_for :body do
     
      html_escape
      image
      youtube :width => 640, :height => 480
      vimeo :width => 640, :height => 480
      link :target => "_blank", :rel => "nofollow"
      simple_format
    end
  
 
  
end
