class Plagg < ActiveRecord::Base
  attr_protected :user_id, :approved
   

  has_many :assets, :dependent => :destroy
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings
  has_many :offers
  has_many :comments, :as => :commentable
  has_many :votes, :dependent => :destroy

  belongs_to :user
  belongs_to :brand, :class_name=>:brand, :foreign_key=>:brand_name
  belongs_to :department
  belongs_to :category
  belongs_to :size
  accepts_nested_attributes_for :assets, :allow_destroy => true


  validates_format_of :body, :with =>/((http|https):\/\/)?(www\.)?(youtube\.com\/watch\?|vimeo\.com\/)()?([a-zA-Z0-9\-\.]+)\/?/i, :allow_blank=>true

  validates_presence_of :title, :description, :price, :department_id, :category_id, :size_id
  validates_length_of :description, :maximum=>185, :message=>"Please keep your description under {{count}} characters."
  validates_length_of :price, :maximum=>6, :message=> "No more than 6 digits please."
  validates_numericality_of :price, :message => "Only numbers please."
  validates_inclusion_of :is_tradeable, :in => [ true, false ]

  before_validation_on_create :unapprove
  
  define_index do
    indexes title
    indexes description
    indexes user.username,      :as => :user, :sortable => true
    indexes department.name,    :as => :department
    indexes category.name,      :as => :category
    indexes size.name,          :as => :size
  end


   auto_html_for :body do
     
      html_escape
      image
      youtube :width => 640, :height => 480
      vimeo :width => 640, :height => 480
      link :target => "_blank", :rel => "nofollow"
      simple_format
    end

  protected

  def unapprove
    self.approved = false unless approved
    true
  end
end
