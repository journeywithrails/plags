class Asset < ActiveRecord::Base
  belongs_to :plagg

  has_attached_file :data, :styles => { :zoom => "600x940#", :preview => "300x470#", :miniview => "48x48#", :tile => "135x235#" , :byt_view=>"97x152#"},
                           :path => ":rails_root/public/images/assets/:style/:id/:filename",
                           :url => "/images/assets/:style/:id/:filename",
                           :default_url => "/images/assets/:style/missing.png"
  validates_attachment_presence :data
  validates_attachment_size :data, :less_than => 10.megabytes
  
  before_post_process :is_image?
  after_create :reprocess!

  def is_image?
    !(data_content_type =~ /^image/).nil?
  end

  def reprocess!
    data.reprocess!
  end
end
