require 'test_helper'

class UserTest < ActiveSupport::TestCase
  context "the User class" do
    setup do
      @user = Factory.create(:user)
    end

    subject { @user }

    should_have_many :plaggs,   :dependent => :destroy
    should_have_many :posts,    :dependent => :destroy
    should_have_many :pages,    :dependent => :destroy
    should_have_many :comments, :dependent => :destroy
    should_have_many :watchings, :dependent => :destroy
    should_have_many :categories, :through => :watchings
    should_have_many :watchees,   :through => :watchings

    should_have_attached_file               :avatar
    should_validate_attachment_content_type :avatar, :valid => [ "image/jpeg", "image/jpg", "image/pjpeg", "image/png", "image/x-png", "image/gif" ] 
    should_validate_attachment_size         :avatar, :less_than => 10.megabytes

    should_validate_presence_of   :username,      :email_address
    should_validate_uniqueness_of :username,      :case_sensitive => false
    should_validate_uniqueness_of :email_address, :case_sensitive => false

    should_allow_mass_assignment_of     :password
    should_not_allow_mass_assignment_of :password_hash, :role

    should "return the user's ID on successful authentication" do
      id = User.authenticate(@user.username, "password")
      assert_equal @user.id, id
    end

    should "return nil on failed authentication" do
      assert_nil User.authenticate(@user.username, "junk")
    end
  end

  context "a User instance" do
    context "without a password_hash" do
      setup do
        @user = Factory.build(:user)
      end
      
      subject { @user }

      should_validate_presence_of :password, :password_confirmation
    end

    context "with a password_hash" do
      setup do
        u = Factory.create(:user)
        @user = User.find(u.id)
      end

      context "and no password set" do
        should "be valid" do
          assert_nil @user.password
          assert_nil @user.password_confirmation
          assert @user.valid?
        end
      end
      
      context "and a new password set" do
        setup { @user.password = "new_password" }

        subject { @user }

        should_validate_presence_of :password_confirmation
      end
      
      should "not change the password_hash when updating other attributes" do
        old_hash = @user.password_hash
        @user.email_address = Factory.next(:email_address)
        @user.save
        assert_equal old_hash, @user.password_hash
      end
    end
  end
end
