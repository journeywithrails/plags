require 'test_helper'

class TagTest < ActiveSupport::TestCase
  context "the Tag class" do
    setup do
      Factory.create(:tag)
    end

    should_have_many :taggings, :dependent => :destroy
    should_have_many :plaggs, :through => :taggings

    should_validate_presence_of :name, :group
    should_validate_uniqueness_of :name, :case_sensitive => false
  end
end
