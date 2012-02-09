require 'bcrypt'
require 'digest/sha2'

class User < ActiveRecord::Base
  class Role
    UNVERIFIED    = 0
    MEMBER        = 1
    ADMINISTRATOR = 2
  end

  attr_accessor :password
  attr_protected :password_hash, :role, :fb_user_id, :fb_email_hash, :confirmation_token
#  attr_accessor :networks_ids
  attr_accessor :agree
  has_many :plaggs,     :dependent => :destroy
  has_many :posts,      :dependent => :destroy
  has_many :pages,      :dependent => :destroy
  has_many :comments,   :dependent => :destroy
  has_many :watchings,  :foreign_key => "watcher_id", :dependent => :destroy
  has_many :categories, :through => :watchings, :conditions => "watchings.watchable_type = 'Category'"
  has_many :departments, :through => :watchings, :conditions => "watchings.watchable_type = 'Department'"
  has_many :watchees,   :through => :watchings, :conditions => "watchings.watchable_type = 'User'"
  has_many :monitorings
  has_many :networks_users
  has_many :networks, :through => :networks_users

  accepts_nested_attributes_for :networks_users


  has_attached_file :avatar, :styles => { :thumb => "48x48#" },
                             :path => ":rails_root/public/images/:attachment/:style/:id/:filename",
                             :url => "/images/:attachment/:style/:id/:filename",
                             :default_url => "/images/:attachment/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => [ "image/jpeg", "image/jpg", "image/pjpeg", "image/png", "image/x-png", "image/gif" ]
  validates_attachment_size :avatar, :less_than => 10.megabytes
  validates_acceptance_of :agree ,:message=>"the Terms of Service"
  validates_uniqueness_of   :username,              :case_sensitive => false, :message=>"Username is already taken."
  validates_presence_of     :username
  validates_presence_of     :role
  validates_presence_of     :email_address,          :unless => :facebooker?
  validates_presence_of     :password,              :if => :password_required?
  validates_presence_of     :password_confirmation,  :if => :password_confirmation_required?
  validates_confirmation_of :password,       :if => :password_confirmation_required?,:message => "Does not compare to password."
  validates_format_of :email_address, :with => /\b[a-z0-9._%-]+@[a-z0-9.-]+\.[a-z]{2,4}\b/, :live_validator => /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/, :message => "invalid e-mail format"
  validates_format_of :password, :with => /^[^&()%\/]*$/ ,:live_validator =>/^[^&()%\/]*$/, :message=>"No ( ) / % & allowed."
  validates_uniqueness_of   :email_address,         :case_sensitive => false, :message=>"e-mail is already taken."
 validates_length_of :username, :maximum=>10

  before_validation_on_create :set_unverified_attributes
  before_save                 :generate_password_hash
  before_update               :register_with_facebook_if_necessary

  def self.authenticate(username, password)
    u = find_by_username(username)
    u && (BCrypt::Password.new(u.password_hash) == password) ? u.id : nil
  end
  
  def self.confirm(token = nil)
    u = find_by_confirmation_token(token)

    if u && u.role < User::Role::MEMBER
      u.role = User::Role::MEMBER 
      u.save!
    end

    u
  end


  def self.arbitrary_hash
    encrypt("#{Time.now.to_s.split(//).sort_by {rand}.join}")
  end

  def self.find_by_facebook(facebooker)
    find_by_fb_user_id(facebooker.uid) || find_by_fb_email_hash(facebooker.email_hashes)
  end

  def self.create_from_facebook_session(facebooker)
    password = arbitrary_hash

    u = User.new({
      :username => facebooker.name,
      :password => password,
      :password_confirmation => password
    })

    u.role = User::Role::MEMBER
    u.fb_user_id = facebooker.uid.to_i
    u.save(false)

    u
  end

  def verified?
    role > User::Role::UNVERIFIED
  end

  def authorized?
    role > User::Role::MEMBER
  end

 
  def link_to_facebook_user(facebooker)
    uid = facebooker.uid
    
    if existing = User.find_by_fb_user_id(uid)
      self.transaction do
        existing.fb_user_id = nil
        existing.save(false)
        
        self.fb_user_id = uid
        save(false)
      end
    else
      self.fb_user_id = uid
      save(false)
    end

    self
  end

  def facebooker?
    self.fb_user_id && self.fb_user_id > 0
  end

  def watchers
    ids = Watching.all(:select => "watcher_id", :conditions => { :watchable_type => "User", :watchable_id => id }).map(&:watcher_id)
    User.find(ids)
  end

  def watching?(watchable)
    case watchable.class.to_s
    when "User"
      watchees.include?(watchable)
    when "Category"
      categories.include?(watchable)
    when "Department"
      departments.include?(watchable)
    else
      false
    end
  end

  def location
    if !city.blank?
       city + ' i '  + county 
    elsif !county.blank?
       county
    else
      ''
    end
  end

  def location=(new_location)
    unless new_location.blank?
      if new_location.include?(' i ')
        city_county = new_location.split(/ i /) 
        self.city = city_county[0]
        self.county = city_county[1]
      else
        self.city = ''
        self.county = new_location
      end
    end
  end



#added for remember me functionality
  def self.encrypt(string)
    Digest::SHA256.hexdigest(string)
  end

# Encrypts the password with the user salt
def encrypt(password)
  self.class.encrypt(password)
end



 def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token = encrypt("#{email_address}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  
  
  
  
  protected

  def register_with_facebook_if_necessary
    if email_address_changed? || (email_address && fb_email_hash.blank?)
      self.fb_email_hash = Facebooker::User.hash_email(email_address)
      user = [{ :email => fb_email_hash, :account_id => id }]
    #  Facebooker::User.register(user)
    end
  end

  def set_unverified_attributes
    self.role ||= User::Role::UNVERIFIED
    self.confirmation_token = self.class.arbitrary_hash
  end

  def password_required?
    password_hash.blank?
  end

  def password_confirmation_required?
    !password.blank?
  end

  def generate_password_hash
    self.password_hash = BCrypt::Password.create(password) unless password.blank?
  end


def self.random_password(len)
    chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    random_password = ''
    1.upto(len) { |i| random_password << chars[rand(chars.size-1)] }
    return random_password
end







end